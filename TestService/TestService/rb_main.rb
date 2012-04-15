#
#  rb_main.rb
#  TestService
#
#  Created by Mateus Armando on 30.03.12.
#  Copyright 2012 Sean Coorp. INC. All rights reserved.
#
framework 'Foundation'
framework 'Cocoa'
framework 'XPCKit'
XPCService.runServiceWithConnectionHandler -> connection do
    connection._sendLog("Multiply received a connection")
    connection.setEventHandler -> message, connection do
        connection._sendLog("Multiply received a message! #{message}")
        if message['operation'] == "multiply"
            values = message['values']
            
            # calculate the product
            product = 1.0
            values.inject(1) { |product, n| product * n }
            
            connection.sendMessage({result: product })
        end
        
        if message['operation'] == "read"
            path = message["path"]
            data = NSFileManager.defaultManager.contentsAtPath(path)
            file_handle = NSFileHandle.fileHandleForReadingAtPath(path)
            
            # connection._sendLog("data #{data.length} bytes handle #{file_handle}")
            
            connection.sendMessage({ data: data, file_handle: file_handle })
        end
        
        if message['operation'] == "whatTimeIsIt"
            connection.sendMessage({ date: NSDate.date })
        end
        
    end
end