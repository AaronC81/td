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
      else
        TD::CLI.unknown_command
      end
    end

    # Prints a pretty, formatted overview of the "Today" list.
    def self.overview
      items = Data.items

      if items.empty?
        puts "Looks like there's nothing to do!"
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

    # Prints an "unknown command" message.
    def self.unknown_command
      puts "#{"Unknown command.".bright.red} Try again."
    end
  end
end