# Badger

To get started, you need a Lisp implementation with [Quicklisp][quick] installed.

Run your Lisp REPL. Then do:

    (load "badger.asd")
    (ql:quickload :badger)
    (badger:start-server)

Then, using an iPad or iPhone, navigate Safari to port 4444 on the host your Lisp is running on.

To stop the server, type this in the Lisp REPL:

    (badger:stop-server)

 [quick]: https://www.quicklisp.org/beta/
