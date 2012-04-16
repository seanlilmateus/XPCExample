#
#  rb_main.rb
#  XPCExample
#
#  Created by Mateus on 30.03.12.
#
framework 'Foundation'
framework 'Cocoa'
framework 'XPCKit'

XPCService.runServiceWithConnectionHandler ->  connection do
  connection._sendLog("Multiply received a connection")
  connection.setEventHandler -> message, connection do
    connection._sendLog("Multiply received a message! #{message}")
    if message[:operation] == "multiply"
      values = message[:values]

      # calculate the product
      product = values.inject(1, :*)
      connection.sendMessage({result: product})
    end

    if message[:operation] == "read"
      path = message[:path]
      data = NSFileManager.defaultManager.contentsAtPath(path)
      file_handle = NSFileHandle.fileHandleForReadingAtPath(path)
      # file = File.open(path,'r')
      # connection._sendLog("data #{data.length} bytes handle #{file_handle}")
      connection.sendMessage({data: data, file_handle: file_handle })
    end

    connection.sendMessage({ date: NSDate.date }) if message[:operation] == "whatTimeIsIt"
  end
end
