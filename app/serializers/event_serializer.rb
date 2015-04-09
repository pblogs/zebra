class EventSerializer < ActiveModel::Serializer
  attributes :id, :job_id, :title, :start, :end,
             :backgroundColor, :borderColor, :editable

  def job_id
    object.eventable.id
  end

  def title
    status = object.eventable.completion.present? ? object.eventable.completion.name : 'No Status'
    "Job ##{object.eventable.id} - #{object.name} (#{status})"
  end

  def start
    object.started_on
  end

  def end
    object.completed_on.present? ? object.completed_on : Date.today
  end

  def overlap
    false
  end

  # def url
  #   "/admin/jobs/#{object.eventable_id}"
  # end

  def backgroundColor
    object.eventable.completion.present? ? "#{object.eventable.completion.color}" : 'rgb(105, 105, 105)'
  end

  def borderColor
    #object.completion.present? ? object.completion.color : '#3a87ad'
  end

  def editable
    #return false if object.completed?
    true
  end
end
