This is a gitutorial so you may want to start at the first commit
(SHA: 59816053ce89c243c037acdc42a3b7d309ab5cc4) and work your way up
to HEAD.

This is all just some kind of transcript of my learning efforts so it
*could* contain stupid mistakes, but I test all commits before pushing
so is hope there won't be any fatal errors.

## Setting up the database

Run this inside a Factor listener.

1.  as of commit ab47b145ce7de036017b8c66ff490c693f927588:
        USING: blog db db.sqlite furnace.alloy ;
        "sqlite.db" <sqlite-db> [
            \ post ensure-table
            init-furnace-tables
        ] with-db

2.  as of commit 0e528d64dfe82f5be3da16ccd2f8a094d20f277c:
        USING: blog db db.sqlite ;
        "sqlite.db" <sqlite-db> [ \ post ensure-table ] with-db
