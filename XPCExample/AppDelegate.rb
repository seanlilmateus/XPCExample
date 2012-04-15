#
#  AppDelegate.rb
#  XPCExample
#
#  Created by Mateus on 30.03.12.
#
framework 'XPCKit'

class AppDelegate
  attr_accessor :window, :text_view

  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
      @text_view.instance_eval { def <<(string);textStorage.mutableString.appendString(string + "\n"); end }
    start
  end

  def awakeFromNib
    @home = NSHomeDirectory().split("/")[2]
    
    begin
      file = File.open("/Users/#@home/Library/Safari/Bookmarks.plist",'r')
    rescue Exception => e
      warn e
    end
    
  end

  def start
    math_connection = XPCConnection.alloc.initWithServiceName("de.mateus.macruby.TestService")
    math_connection.eventHandler = proc do |message, in_connection|
      result = message[:result]
      data = message[:data]
      file_handle = message[:file_handle]
      date = message[:date]

      if result
        NSLog("We got a calculation result! %@", result)
        @text_view << "We got a calculation result! #{result} "
      elsif(data || file_handle)
        new_data = file_handle.readDataToEndOfFile
        NSLog("We got a file handle! Read %i bytes - %@", new_data.length, file_handle)
        @text_view << "We got a file handle! Read #{new_data.length} bytes - #{file_handle.description} "
      elsif(date)
        NSLog("It is now %@", date)
        @text_view << "It is now #{date} "
      end
    end

    read_connection = XPCConnection.alloc.initWithServiceName("de.mateus.macruby.TestService")
    read_connection.dispatchQueue = Dispatch::Queue.new("de.mateus.read_service").dispatch_object
    read_connection.eventHandler = proc do |msg, connection|
      data = msg[:data]
      file_handle = msg[:file_handle]

      if data || file_handle
        new_data = file_handle.readDataToEndOfFile
        if new_data
          NSLog("We got maybe mapped data! %i bytes - Equal? %@", data.length, (new_data.isEqualToData(data) ? "YES" : "NO"))
          @text_view << "We got maybe mapped data! #{data.length} bytes - Equal? #{(new_data.isEqualToData(data) ? 'YES' : 'NO')} "
        else
          NSLog("We got a file handle! Read %i bytes - %@", new_data.length, file_handle)
          @text_view << "We got a file handle! Read #{new_data.length} bytes - #{file_handle}"
        end
      end
    end


    multiply_data = { operation: "multiply", values: [7, 6, 1.67] }
    read_data = { operation: "read", path: "/Users/#@home/Library/Safari/Bookmarks.plist" }

    loaded_data = NSFileManager.defaultManager.contentsAtPath(read_data[:path])
    loaded_handle = NSFileHandle.fileHandleForReadingAtPath(read_data[:path])
    works = (loaded_data.nil? && loaded_handle.nil?) ? "working" : "NOT working"
    NSLog("Sandbox is %@ at path %@, got %i bytes and a file handle %@", works, read_data[:path], 0, loaded_handle)
    
    math_connection.sendMessage(multiply_data)
    read_connection.sendMessage(read_data)
    math_connection.sendMessage({operation: "whatTimeIsIt"})
  end
end
