---
layout: post
title: An Introduction (to Bash History)
categories:
  - blog
fullview: true
---

Blogs --- or at least my blogs --- always seem to start the same way. "Hi,
I'm `$NAME`. I do `$ACTIVITY`, and plan on using this blog to write about
`$STUFF`." Which is not only boring, but really embarrassing when that's
the only thing on the blog six months later.

So instead of doing that again, I'm going to try to write an off-the-cuff
piece on bash history. Because at least that way this post might be useful
to someone.

### Basic Time Travel

"Bash history" doesn't mean bash's history, but rather your history in
bash. By default, the shell keeps a running tab of all the commands you've
typed. You're probably already of aware of this through the simplest of
bash history functions: pressing up to scroll through previous commands. If
you haven't tried this before, go do it now. Just type in a bunch of
commands --- even invalid ones --- and then use the up/down arrow keys to
see browse through your history. You can even edit commands before
rerunning them, which is handy when building complicated invocations.

This is really useful all on its own, but it has some drawbacks. For
example, if you're looking for a command you ran some time ago it might
take awhile to get there. If only there were some search functionality.

Hey, go to your shell and press `^R`, will you?

    (reverse-i-search)`':

There you go. Type a phrase and then press `^R` again step back through
a filtered version of your history that only includes commands with your
search phrase. E.g.,

    (reverse-i-search)`git': git commit -m "Creating a placeholder/test
    page."

Notice that your search term appears just after `(reverse-i-search)`, in
case you forgot what you were looking for. And do remember that you have to
use `^R` to move back through the history; if you press the up/down keys
you'll start browsing the history starting at your currently selected
command. Potentially useful, but usually just confusing.

### The Historical Record

Up/down history and search are great, but can be kind of time consuming if
you want to edit earlier commands. Luckily, bash has a slick --- if
somehwat unintuitive --- notation for referring to past commands and parts
of past commands.

The most basic instance of this is `!!`, which refers to the last executed
command. At its simplest, it's an alternative to &uArr;&crarr; for
rerunning the command you just ran:

    $ ls *monkey*.md
    2013-11-19-monkey.md
    $ !!
    ls *monkey*.md
    2013-11-19-monkey.md

Note that it prints the command it's going to run before its output. This
will be handy when you get fancier with this.

Rerunning a command isn't super interesting. But what about building long
chains of commands?

    $ grep -R monkey .
    [...long output...]
    $ !! | sed 's/monkey/ape'
    grep -R monkey | sed 's/monkey/ape'
    [...more output...]
    $ !! | cut -f1
    grep -Rmonkey | sed 's/monkey/ape' | cut -f1

... and so on. The `!!` notation lets you easily re-run and build-upon your
just executed command. But what if you want to run something a bit older?

Well, the `!` prefix is actually the general bash notation for "check the
history and run something matching...". Followed by some letters, for
example, it lets you run the most recently executed command that starts
with those letters. In my personal experience `!mvn` comes in handy:

    $ !mvn
    mvn -Dtest=SomeIntegrationTest#testStuffWorks -Dspring.profiles.active=foo -Psome-maven-profile test

But remember, this works with anything. Maybe you want to rerun a recently
executed `!grep`, or a carefully constructed `!perl` one-liner. Whatever
elaborate shell wizardry you find yourself using, this trick lets you
easily recall them.

Before moving on to my last act, a small but important tip. You might find
yourself *wanting* to run something with `!`, but being concerned that it
isn't what you remembered. After all, you don't want to re-run an `xargs`
thinking your renaming some files only to find out you were using it in
a complicated delete operation. For this, just append `:p` to the history
command. This addendum causes bash to print the command it would execute
*without* actually executing it.

    $ !mvn:p
    mvn -Dtest=SomeIntegrationTest#testStuffWorks -Dspring.profiles.active=foo -Psome-maven-profile test
    $ 

Even better, this drops a copy of that command into your history, so you
can press up to review and edit it before running.

### For Lack of a Better Argument

The last trick I want to share is using the history language for
manipulating arguments.

Here's a common use case that I run into a lot. I want to delete a bunch of
files using a pattern, but I want to make sure the pattern works before
I invoke `rm`. So I build up the expression using `ls` first:

    $ ls this[^x]that{or,the,other}*.txt

Now I've got the great command, but what's the fastest way to execute it
without running the risk of introducing an error into the pattern?

    $ rm !*

The `!*` notation is shorthand for "all the arguments of the preceding
command". (If you want to use it with an older reference, you can do
something like `!ls:*`. Note the colon separating your prefix match from
the asterisk.) There's also `!$`, meaning the last argument of the
preceding command, and `!:2` if you want to just grab the second argument.

One last trick:

   # Note the misspelled command
   $ mnv -Dthis=that -Dx=y -Dfalse=true -Dup=down
   org.oss.someplace.goal:plugin
   -bash: mnv: command not found
   $ ^mnv^mvn
   mvn -Dthis=that -Dx=y -Dfalse=true -Dup=down

Using `^keyword^replacement`, you can do simple search-and-replace to
correct typos without annoying retyping or editing.

---

Hopefully this was a useful taste of what the bash history system can do
for you. For more information, I highly recommend setting aside an
afternoon to read the "HISTORY EXPANSION" section of the bash manpage. It's
meaty --- gristly, even --- but messing around with the syntax it describes
will do amazing things for your life in the command line.
