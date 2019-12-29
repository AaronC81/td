require 'trello'

module TD
  module Data
    # Returns an array of TD::Item instances, one for each item of the "Today"
    # list.
    def self.items
      Trello::List.find(Config.today_list).cards.map do |card|
        Item.new(card.name, card_done?(card), card)
      end
    end

    # Returns true if the given Trello::Card is labelled with the "Done" label.
    def self.card_done?(card)
      card.labels.map(&:id).include?(Config.done_label)
    end

    # Removes the "Done" label from the given Trello::Card, if it is present.
    def self.mark_not_done(card)
      card.remove_label(Trello::Label.find(Config.done_label))
    end

    # Adds the "Done" label from the given Trello::Card, if it is not present.
    def self.mark_done(card)
      card.add_label(Trello::Label.find(Config.done_label))
    end

    # Given a 0-based index and the sublist to search in (:to_do or :done),
    # returns the TD::Item at that index.
    def self.item_at_index(index, sublist)
      case sublist
      when :done
        items.select(&:done)[index]
      when :to_do
        items.reject(&:done)[index]
      else
        raise "invalid sublist type #{sublist}"
      end
    end
  end
end