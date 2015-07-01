class Scenario < ActiveRecord::Base

  has_many :scenario_session

  def node(id = 0, obj = self)
    object = nil

    if obj == self
      obj = JSON.parse self.content
      obj = obj["scenario"]['briefing']
    end

    if id == 0
      return obj
    else
      obj['children'].each do |child|
        if child["id"] == id
          object = child
          break
        end

        if child['children'].present?
          object = self.node(id, child)
          if object.present?
            break
          end
        end
      end
    end

    return object
  end

end
