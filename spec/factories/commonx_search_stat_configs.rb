# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do


  factory :commonx_search_stat_config, :class => 'Commonx::SearchStatConfig' do
    resource_name   'kustomerx_customers'
    stat_function   %& {:week => models.all(:select => "strftime('%Y/%m/%d', kustomerx_customers.created_at) as Dates, sum(kustomerx_customers.id) as Payments", :group => "strftime('%Y/%W', kustomerx_customers.created_at)"),
  :month => models.all(:select => "strftime('%Y/%m/%d', kustomerx_customers.created_at) as Dates, sum(kustomerx_customers.id) as Payments", :group => "strftime('%Y/%m', kustomerx_customers.created_at)"),
  :quart => models.all(:select => "strftime('%Y/%m/%d', kustomerx_customers.created_at) as Dates, sum(kustomerx_customers.id) as Payments, 
  CASE WHEN cast(strftime('%m', kustomerx_customers.created_at) as integer) BETWEEN 1 AND 3 THEN 1 WHEN cast(strftime('%m', kustomerx_customers.created_at) as integer) BETWEEN 4 and 6 THEN 2 WHEN cast(strftime('%m', kustomerx_customers.created_at) as integer) BETWEEN 7 and 9 THEN 3 ELSE 4 END as quarter",  :group => "strftime('%Y', kustomerx_customers.created_at), quarter"),
  :year => models.all(:select => "strftime('%Y/%m/%d', kustomerx_customers.created_at) as Dates, sum(kustomerx_customers.id) as Payments", :group => "strftime('%Y', kustomerx_customers.created_at)")
  } &
    stat_summary_function   " <%=t('Payment Total($)') %>:&nbsp;&nbsp;<%= number_with_precision(number_with_delimiter(@s_s_results_details.models.sum(:id)), 
          :precision => 2) %> "
    labels_and_fields %& {
:start_date_s => { :label => t('Start Date'), :as => :string, :input_html => {:size => 40}},
:end_date_s => { :label => t('End Date'), :as => :string, :input_html => {:size => 40}},
:customer_status_category_id_s => { :label => t('Customer Status Category'), :collection =>Commonx::CommonxHelper.return_misc_definitions('customer_status'),  :label_method => :name, :value_method => :id,   :include_blank => true }, 
:keyword_s => { :label => t('Keyword')},
:zone_id_s => { :label => t('Zone'), :collection => Authentify::Zone.where(:active => true).order('ranking_order'),
              :label_method => :zone_name, :value_method => :id, :include_blank => true },
:active_s => {:collection => [[t('Yes'), true], [t('No'), false]] ,    :label => t('Active'), :include_blank => true },
:sales_id_s => {:label => t('Sales'), :collection => Authentify::User.scoped , :label_method => :name, :value_method => :id, :include_blank => true  },
} &
      search_where  %& {
:customer_status_category_id_s => Proc.new { models.where('kustomerx_customers.customer_status_category_id = ?', params[:customer][:customer_status_category_id_s]) },
:start_date_s => Proc.new { models.where('kustomerx_customers.since_date > ?', params[:customer][:start_date_s])},
:end_date_s   => Proc.new { models.where('kustomerx_customers.since_date < ?', params[:customer][:end_date_s])},
:keyword_s    => Proc.new { models.where('kustomerx_customers.name like ? ', params[:customer][:keyword_s])},
:customer_id_s  => Proc.new { models.where('kustomerx_customers.id = ?', params[customer][:customer_id_s] )},
:sales_id_s   => Proc.new { models.where('kustomerx_customers.sales_id = ?', params[:customer][:sales_id_s]) },
:zone_id_s  => Proc.new { models.where('kustomerx_customers.zone_id = ?',  params[:customer][:zone_id_s]) },
:active_s => Proc.new {models.where('kustomerx_customers.active = ?', params[:customer][:active_s] == 'true' ) }
} &
   
    time_frame  %& [['week', t('Week')],  ['month', t('Month')], ['quarter',  t('Quarter')], ['year', t('Year')]] &
    search_results_period_limit " Proc.new { models.where('kustomerx_customers.created_at > ?', search_stats_max_period_year.years.ago) }"
    search_list_form 'index_partial'
    stat_header 'Dates, Payment Total'
    search_params "{}"
  end

end
