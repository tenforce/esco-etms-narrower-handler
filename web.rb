require 'net/http'
require 'json'
# require 'pry'# for breakpoints

###############
#### Calls ####
###############

get '/:id' do
    content_type 'application/vnd.api+json'
    result = {}
    query = ' with <' + settings.graph.to_s + '> '
    query += ' delete { ?narrower <http://sem.tenforce.com/vocabularies/etms/hasPublicationStatus> ?oldStatus . } '
    query += ' insert { ?narrower <http://sem.tenforce.com/vocabularies/etms/hasPublicationStatus> ?newStatus . } '
    query += " where { ?concept ?uuid \'"
    query += params[:id] + "\' ."
    query += ' ?narrower <http://www.w3.org/2004/02/skos/core#broader>+ ?concept ; '
    query += ' <http://sem.tenforce.com/vocabularies/etms/hasPublicationStatus> ?oldStatus .'
    query += ' optional{ ?narrower <http://purl.org/dc/terms/issued> ?issued . }'
    query += ' BIND( IF(bound(?issued), <http://sem.tenforce.com/vocabularies/etms/publicationStatusReadyForDeprecation> , <http://sem.tenforce.com/vocabularies/etms/publicationStatusDeleted>) as ?newStatus)'
    query += ' }'

    begin
      log.info query
      update(query)
      log.info "Done"
    rescue Exception => e
        log.error e.message
        log.error e.backtrace.join("\n")
    end

    result['handled'] = query
    puts params[:id].to_s
    status 200
    result.to_json
end
