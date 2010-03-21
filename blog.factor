! Copyright (C) 2010 Maximilian Lupke.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors db.tuples db.types kernel ;
IN: blog

TUPLE: post id title content created-at ;

\ post "posts" {
    { "id" "id" INTEGER +db-assigned-id+ }
    { "title" "title" { VARCHAR 100 } +not-null+ }
    { "content" "content" TEXT +not-null+ }
    { "created-at" "created_at" TIMESTAMP }
} define-persistent

: <post> ( id -- post )
    \ post new swap >>id ;

: post ( id -- post )
    <post> select-tuple ;

: recent-posts ( num -- posts )
    f <post> >query
        swap >>limit
        "created_at desc" >>order
    select-tuples ;
