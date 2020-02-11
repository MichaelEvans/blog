---
layout: post
title: "Dropping Columns Like It's Hot"
date: 2020-02-10 20:03:03 -0500
comments: true
categories: [Android]
description: "Dropping Database Columns with SQLite"
keywords: "Android"
---

Recently, I was doing some code cleanup and noticed that there were some data in the database that was no longer needed. I think most developers clean up their codebase of deprecated patterns and unused code, but I personally have not done a good job of ensuring that the same cleanup happens for unused columns in my databases.

Dropping tables that are no longer used is pretty easy (especially if you can just use something like Room's [Migrations](https://developer.android.com/training/data-storage/room/migrating-db-versions)) but when trying to remove unused columns, I ran into an unexpected problem. I thought to myself, it’s pretty easy to add or rename a column, why would dropping one be any harder? The existing database library I was using already had a convenient "drop column" method, so I simply called that and tried to run the migration. During the process, I ended up with a `ForeignKeyConstraintException`! I quickly scanned the schema to see what could have caused that, and didn't see anything obvious. The table I was trying to modify didn't have any foreign keys itself, and the column I was dropping was not a foreign key. Curious to understand what was happening, I started to dig into what this method call was doing.

<!-- more -->

I saw that although you can add a column with SQLite's `ALTER TABLE ${tableName} ADD COLUMN ${columnName} ${columnType}` statements, there's [no support for removing a column out of the box](https://www.sqlite.org/lang_altertable.html). The library method I was using emulates dropping a column by doing the following:

1. Rename the existing table into `$tablename_old`
2. Creating a new table with all the existing columns, minus the one we don’t want
3. Copying all the data from `$tablename_old` to `$tablename`
4. Dropping `$tablename_old`, since we don’t need it anymore.

This process seems to make a lot of sense - since we can’t remove the column on its own, let’s just make a new table with the structure we want and copy over the data that we want to keep. So why does this process not work?

### The Gotcha!

If you read the SQlite documentation linked above closely, you might have noticed an important note:

> Compatibility Note: The behavior of ALTER TABLE when renaming a table was enhanced in versions 3.25.0 (2018-09-15) and 3.26.0 (2018-12-01) in order to carry the rename operation forward into triggers and views that reference the renamed table. This is considered an improvement. Applications that depend on the older (and arguably buggy) behavior can use the PRAGMA legacy_alter_table=ON statement or the SQLITE_DBCONFIG_LEGACY_ALTER_TABLE configuration parameter on sqlite3_db_config() interface to make ALTER TABLE RENAME behave as it did prior to version 3.25.0.

What this means is that when we use `ALTER` to rename a table, any triggers/views/foreign keys that reference that table will now be updated to support it. As an example:

Let's say we had a table `users` with a few columns: `id`, `first_name`, `last_name`, and `age`, and we had a table `orders` with the columns `id`, `order_number` and `user_id`, where `user_id` was a foreign key back to the `users` table. It might look a little like this:

{% img center /images/2020/02/10/before_step1.png 400 400 %}

Following the steps above, let's try to drop the `age` column. First we'll rename the existing table into `users_old`, and create the new table:

{% img center /images/2020/02/10/before_step2.png 400 600 %}

Then we copy the the data, and try to drop `users_old`, and this is where we run into the exception. The grey line in the diagram is our foreign key association, and that will no longer be valid because the `orders` table will be trying to reference `users_old` which we are trying to drop.

{% img center /images/2020/02/10/before_step3.png 400 600 %}

Fortunately the documentation lists out a better sequence of steps to perform this operation:

1. Create the new table
2. Copy over the data we need
3. Drop old table
4. Rename the new table with the name of the old table

Looking at it more visually - we'll start with the same tables and create a new table named `users_new` to hold the preserved data:

{% img center /images/2020/02/10/after_step1.png 400 600 %}

Then we'll do the data copy, drop, the old table (but the foreign key relation will still reference the `users` table), and rename `users_new` to `users`.

{% img center /images/2020/02/10/after_step2.png 400 400 %}

These steps will ensure that no existing links (views, triggers, etc) are modified. That way when we rename the table in the final step, the existing links will end up referencing the new table already.

{% img center /images/2020/02/10/after_step3.png 400 400 %}

TLDR:

```
override fun migrate(database: SupportSQLiteDatabase) {
    // Create the new table
    database.execSQL("CREATE TABLE users_new (id INTEGER, first_name TEXT, last_name TEXT, PRIMARY KEY(userid))")
    // Copy the data
    database.execSQL("INSERT INTO users_new (id, first_name, last_name) SELECT id, first_name, last_name FROM users")
    // Remove the old table
    database.execSQL("DROP TABLE users")
    // Change the table name to the correct one
    database.execSQL("ALTER TABLE users_new RENAME TO users")
}
```

Hopefully this discovery helps you better clean up those unused columns in your databases!
