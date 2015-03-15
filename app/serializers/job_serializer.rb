class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end,
        :url, :backgroundColor, :borderColor, :editable

  def title
    object.completion.present? ? "#{object.name} - #{object.completion.name}" : object.name
  end

  def start
    object.started_on.beginning_of_day
  end

  def end
    object.completed_on.present? ? object.completed_on.end_of_day : Date.today.end_of_day
  end

  def url
    "/admin/jobs/#{object.id}"
  end

  def backgroundColor
    object.completion.present? ? object.completion.color : '#3a87ad'
  end

  def borderColor
    object.completion.present? ? object.completion.color : '#3a87ad'
  end

  def editable
    # object.completed_on.present? ? false : true
    false
  end
end
