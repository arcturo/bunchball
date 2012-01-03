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
    attr_accessor :name, :points, :category, :prefix_match
    
    def initialize(name)
      @name = name
    end
    
    # Add other methods as needed...
    def points(amount)
      @points = amount
    end

    def prefix_match(value)
      @prefix_match = (value ? 1 : 0)
    end

    def category(cat)
      @category = cat
    end
    
    # obviously may need to pre-process some things here
    def attributes
      {:name => @name, :points => @points, :category => @category, :prefixMatch => @prefix_match}
    end
  end

  def self.map_actions(&blk)
    new.instance_eval(&blk)
  end

  def initialize
    @prefix = ""
  end

  def prefix_separator
    '_'
  end

  def action(name, &blk)
    a = ActionRunner.new("#{[@prefix, name].join(prefix_separator)}").instance_eval(&blk)

    if (tag_id = Bunchball::Nitro::Actions.get_tag_id(a.name))
      Bunchball::Nitro::Actions.update(tag_id, a.attributes)
    else
      Bunchball::Nitro::Actions.create(a.name, a.attributes)
    end
  end

  def prefix(name, &blk)
    old_prefix = @prefix
    @prefix += name + prefix_separator

    action(@prefix) do
      prefix_match true
    end

    instance_eval(&blk)

    @prefix = old_prefix
  end
end
