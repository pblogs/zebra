class JobEstimate < ActiveRecord::Base
  has_many :estimate_items
  has_many :assets, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :estimate_items, allow_destroy: true
  accepts_nested_attributes_for :assets

  STATE = {
    1 => 'Draft',
    2 => 'Accepted',
    3 => 'Declined',
    4 => 'Sent'
  }

  def mark_as_declined
    update_attributes(state: 3)
  end

  def mark_as_accepted
    client_id = Client.where(name: 'AAA Landscapes & Contracting').first.id
    return unless client_id.present?
    completion_id = Completion.where(name: 'Awarded').first.id

    job = Job.new(
      client_id: client_id,
      name: estimate,
      reference_code: reference,
      completion_id: completion_id,
      pay_status: 'N/A'
      )

    if job.save
      estimate_items.each do |est|
        gun_mark = GunMarkingCategory.where(name: est.title).first
        return unless gun_mark.present?
        job.job_markings.new(
          gun_marking_category_id: gun_mark.id,
          amount: est.quantity,
          rate: est.price
        ).save(validate: false)
      end
    end

    update_attributes(state: 2)
  end
end
