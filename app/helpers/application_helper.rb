module ApplicationHelper

	def errors(obj)
		obj.errors.full_messages.uniq.join('<br> ')
	end

end