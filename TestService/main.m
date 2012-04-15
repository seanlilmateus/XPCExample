//
//  main.m
//  TestService
//
//  Created by Mateus on 30.03.12.
//

#include <xpc/xpc.h>
#import <MacRuby/MacRuby.h>


int main(int argc, char *argv[])
{
	return macruby_main("rb_main.rb", argc, argv);
    
}
