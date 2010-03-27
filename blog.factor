! Copyright (C) 2010 Maximilian Lupke.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors calendar db.tuples db.types furnace.actions
furnace.auth.login furnace.boilerplate furnace.redirection html.forms
http.server.dispatchers kernel present sequences urls validators ;
IN: blog

TUPLE: blog < dispatcher ;

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

: <recent-posts-action> ( -- action )
    <page-action>
        [ 5 recent-posts "posts" set-value ] >>init
        { blog "recent-posts" } >>template ;

: validate-post ( -- )
    {
        { "title" [ v-required v-one-line 100 v-max-length ] }
        { "content" [ v-required ] }
    } validate-params ;

: post-url ( post -- url )
    id>> present "$blog/post/" prepend >url ;

: <new-post-action> ( -- action )
    <page-action>
        [ validate-post ] >>validate
        [
            f <post>
                dup { "title" "content" } to-object
                now >>created-at
            [ insert-tuple ] [ post-url <redirect> ] bi
        ] >>submit
        { blog "new-post" } >>template ;

: <view-post-action> ( -- action )
    <page-action>
        "id" >>rest
        [
            validate-integer-id
            "id" value post from-object
        ] >>init
        { blog "view-post" } >>template ;

: <edit-post-action> ( -- action )
    <view-post-action>
        { blog "edit-post" } >>template ;

: <submit-post-action> ( -- action )
    <page-action>
        [
            validate-integer-id
            validate-post
        ] >>validate
        [
            "id" value <post> dup
            { "title" "content" } to-object
            [ update-tuple ] [ post-url <redirect> ] bi
        ] >>submit ;

: <delete-post-action> ( -- action )
    <action>
        "id" >>rest
        [
            validate-integer-id
            "id" value <post>
            [ delete-tuples ] [ "$blog/" >url <redirect> ] bi
        ] >>display ;

: <blog> ( -- dispatcher )
    blog new-dispatcher
        <recent-posts-action> "" add-responder
        <new-post-action> "new-post" add-responder
        <edit-post-action> "edit-post" add-responder
        <submit-post-action> "submit-post" add-responder
        <delete-post-action> "delete-post" add-responder
        <view-post-action> "post" add-responder
    <boilerplate>
        { blog "page" } >>template
    "Gitutorial Blog" <login-realm>
        f >>secure
    <boilerplate>
        { blog "boilerplate" } >>template ;
