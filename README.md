##XPC-Service with MacRuby

In Mac OS X v10.7 apple has introduced an interprocess communication technology the complements App Sandbox by privilege separation.
This technology enables you to device an app into pieces according to the system resource access that each piece needs.

e.g.:
	- Downlaod-Service, which has nothing, but an internet privilege
	- Filesystem writer, which has privilege to write into file system and so on.

XPC is integrated with GCD; when you create a connection, you associate it with a dispatch queue on which message traffic executes.
Since the XPC-Libraries are written in C without any Cocoa wrapping APIs, it was really difficult to use it with MacRuby. But thanks to [Steve Streza (amazingsyco)](https://github.com/amazingsyco/), there is a nice Cocoa library wrapper [XPCKit](https://github.com/amazingsyco/XPCKit), which can be used with MacRuby.

###this sample code is a port of the XPCKit sample app
###what does it do?
	- the [client](https://github.com/seanlilmateus/XPCExample/blob/master/XPCExample/AppDelegate.rb) sends commands as message, and
	- the [service](https://github.com/seanlilmateus/XPCExample/blob/master/TestService/rb_main.rb) receives this commands, processes it and sends the results back.

##License
this code is licensed under **you can ask whatever you want, but I don't due you shit**, do something nice with the code and have fun!


###Thanks
thanks [@amazingsyco](https://github.com/amazingsyco/) for this great API.