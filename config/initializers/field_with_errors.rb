# Para quando o campo tiver erro colocar um span em torno do campo e do label, 
# ao invés de um div que quebra a estrutura
#ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| 
#	%{<span class="field_with_errors">#{html_tag}</span>}.html_safe 
#}