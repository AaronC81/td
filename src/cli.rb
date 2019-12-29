require 'rainbow/refinement'

using Rainbow

module TD
  module CLI
    # Runs the CLI for a given argument list.
    def self.run(args)
      if args.empty?
        TD::CLI.overview
      elsif args.length == 2 && args[0] == 'done'
        TD::CLI.mark_done(args[1].to_i)
      elsif args.length == 2 && args[0] == 'not'
        TD::CLI.mark_not_done(args[1].to_i)
      elsif args == ['count']
        TD::CLI.count
      elsif args == ['open']
        TD::CLI.open_board
      else
        TD::CLI.unknown_command
      end
    end

    # Prints a pretty, formatted overview of the "Today" list.
    def self.overview
      items = Data.items

      if items.empty?
        puts "Looks like there are no items!"
        return
      end

      done, to_do = items.partition(&:done)

      if to_do.empty?
        puts "You've finished everything today!"
      else
        puts "To Do".underline.bright
        to_do.each.with_index(1) do |item, i|
          puts "#{i.to_s.green}  #{item.title}"
        end
      end

      unless done.empty?
        puts
        puts "Done".underline.bright
        done.each.with_index(1) do |item, i|
          puts "#{i.to_s.green.faint}  #{item.title.faint}"
        end
      end
    end

    # Given a 1-based index into the "Done" list, marks the card at that index
    # as done, printing confirmation.
    def self.mark_done(index)
      item = Data.item_at_index(index - 1, :to_do)
      Data.mark_done(item.trello_card)
      puts "Marked #{item.title.bright} as #{"Done".bright.green}!"
    end

    # Given a 1-based index into the "Done" list, marks the card at that index
    # as not done, printing confirmation.
    def self.mark_not_done(index)
      item = Data.item_at_index(index - 1, :done)
      Data.mark_not_done(item.trello_card)
      puts "Marked #{item.title.bright} as #{"Not Done".bright}."
    end

    # Prints a concise count of the tasks remaining.
    def self.count
      items = Data.items

      if items.empty?
        puts "Looks like there are no items!"
        return
      end

      done, to_do = items.partition(&:done)

      if done.empty?
        puts "You have #{to_do.length} items left to do today."
      elsif to_do.empty?
        puts "You've done all #{done.length} items today!"
      else
        puts "You've done #{done.length} of your #{items.length} items today."
      end
    end

    # Opens the Trello board which contains the "Today" list in a web browser,
    # printing confirmation.
    def self.open_board
      board = Trello::List.find(Config.today_list).board
      puts "Opening #{board.name.bright} in a browser"
      `xdg-open #{board.url}`
    end

    # Prints an "unknown command" message.
    def self.unknown_command
      puts "#{"Unknown command.".bright.red} Try again."
    end
  end
end