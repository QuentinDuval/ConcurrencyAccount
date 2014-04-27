This is a show case of the power and ease of use of the STM based approaches.


It holds several Haskell implementations of concurrent bank accounts.
	1. SyncAccount is an implementation based on re-entrant locks (similar to synchronized methods in Java)
	2. StmAccount is an implementation based on STM
	3. ChanAccount is an implementation based on STM Channels

Then algorithms are built on top of it to:
	- atomically transfers money between the accounts
	- perform atomic observation of their balances
STM implementations shows how easy it is to compose STM blocks to build atomic transactions.


The project also includes a simple test in which these implementations are challenged. Please make sure you use the runtime options +RTS -Nx.
Most of the results I got showed that, in this context of very small transactions:
	- STM performs pretty well.
	- STM channels implementation is about 4 times slower (my guess is that STM channels should be preferred when the content of transaction is bigger).
	- Lock approches are (much) slower, especially with the try lock approach.
