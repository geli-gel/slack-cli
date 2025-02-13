#!/usr/bin/env ruby
require_relative 'workspace'
require 'table_print'
require 'terminal-table'

def main
  puts "\nWelcome to the Ada Slack CLI!"
  workspace = SlackCLI::Workspace.new
  channels_count = workspace.channels.length
  users_count = workspace.users.length
  puts "\n#{channels_count} channels and #{users_count} users loaded"
  
  choice = ""
  until choice == "7" || choice == "quit"
    puts "\nWhat would you like to do?"
    menu_options
    print "Action: " 
    choice = gets.chomp.downcase
    
    case choice
    when "1","list users"
      puts "\n"
      list_users(workspace)

    when "2","list channels"
      puts "\n"
      list_channels(workspace)

    when "3","select user"
      puts "Select User"
      print "Please enter a Username or Slack ID: "
      query = gets.chomp.downcase
      query_result = workspace.select_user(query)
      if query_result == nil
        puts "\nUser with Username or Slack ID '#{query}' does not exist."
      else
        puts "\nUser '#{query_result.name}' selected"
      end
    
    when "4","select channel"
      puts "Select Channel"
      print "Please enter a Channel Name or Slack ID: "
      query = gets.chomp.downcase
      query_result = workspace.select_channel(query)
      if query_result == nil
        puts "\nChannel with Name or Slack ID '#{query}' does not exist."
      else
        puts "\nChannel '#{query_result.name}' selected"
      end

    when "5","details"
      if workspace.show_details == nil
        puts "\nNo user or channel selected."
      else
        puts "\nDetails:"
        puts "#{workspace.show_details}"
      end 

    when "6","send message"
      if workspace.selected == nil
        puts "\nNo recipient selected to send message to."
      else
        puts "Send Message to '#{workspace.selected.name}'"
        print "Please enter message text: "
        message_text = gets.chomp

        until message_text != ""
          puts "No message entered."
          print "Please enter message text: "
          message_text = gets.chomp
        end
        if workspace.send_message(message_text) 
          puts "Message successfully sent"
        end
      end

    when "7","quit"
      break
    else 
      puts "That option does not exist"
    end

  end
  
  puts "Thank you for using the Ada Slack CLI"
end

def menu_options
  numbered_options = [
    ["1", "list users"], 
    ["2", "list channels"], 
    ["3", "select user"],
    ["4", "select channel"],
    ["5", "details"],
    ["6", "send message"],    
    ["7","quit"]
  ]
  menu_table = Terminal::Table.new :headings => ["#", "Action"], :rows => numbered_options
  puts menu_table
end

def list_users(workspace)
  tp workspace.users, :slack_id, :name, :real_name
end

def list_channels(workspace)
  tp workspace.channels, :slack_id, :name, :topic, :member_count
end

main if __FILE__ == $PROGRAM_NAME
