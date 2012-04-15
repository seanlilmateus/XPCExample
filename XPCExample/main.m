//
//  main.m
//  XPCExample
//
//  Created by Mateus on 30.03.12.
//

#import <Cocoa/Cocoa.h>
#import <dispatch/dispatch.h>
#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
