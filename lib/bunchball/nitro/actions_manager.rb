# Bunchball::Nitro::ActionsManager.map_actions do
#   # we'd verify that the required info was added
#   action "tweet" do
#     category :whathaveyou
#     points 23000
#   end
# 
#   # would create action tag 'upload-picture'
#   prefix "upload" do
#     action "picture" do
#       category :whatever
#       points 1000
#     end
#   end
# end

class Bunchball::Nitro::ActionsManager
  class ActionRunner
    attr_accessor :description, :name, :points, :category, :prefix_match

    def initialize(name)
      @name = name
    end

    # Add other methods as needed...
    def points(amount)
      @points = amount
    end

    def description(desc)
      @description = desc
    end

    def prefix_match(value)
      @prefix_match = (value ? 1 : 0)
    end

    def category(cat)
      @category = cat
    end

    # obviously may need to pre-process some things here
    def attributes
      {:name => @name, :points => @points, :category => @category, :prefixMatch => @prefix_match, :description => @description}
    end
  end

  def self.map_actions(&blk)
    new.instance_eval(&blk)
  end

  def initialize
    @prefixes = []
  end

  def prefix_separator
    '_'
  end

  def action(name, &blk)
    a = ActionRunner.new("#{[@prefixes, name].flatten.join(prefix_separator)}")
    a.instance_eval(&blk)

    if (tag_id = Bunchball::Nitro::Actions.get_tag_id(a.name))
      Bunchball::Nitro::Actions.update(tag_id, a.attributes)
    else
      Bunchball::Nitro::Actions.create(a.name, a.attributes)
    end
  end

  def prefix(name, &blk)
    # Go ahead and create this new prefix with any existing @prefix in place (if any).
    # Add the separator onto the end of this tag; for sub-tags, we'll join the separator
    # up in action().
    action(name + prefix_separator) do
      prefix_match true
    end

    @prefixes << name

    instance_eval(&blk)

    @prefixes.pop
  end
end
