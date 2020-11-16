# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'date'
require 'loader'
require 'neo4j-ruby-driver_jars'

# Workaround for missing zeitwerk support as of jruby-9.2.13.0
module Neo4j
  module Driver
    module Internal
    end
    module Net
    end
    module Summary
    end
    module Types
    end
    module Ext
      module Internal
        module Summary
        end
      end
    end
  end
end
# End workaround

Loader.load

module Neo4j
  module Driver
    include_package 'org.neo4j.driver'

    Record = Java::OrgNeo4jDriverInternal::InternalRecord
    Result = Java::OrgNeo4jDriverInternal::InternalResult
    Transaction = Java::OrgNeo4jDriverInternal::InternalTransaction

    module Net
      include_package 'org.neo4j.driver.net'
    end

    module Summary
      include_package 'org.neo4j.driver.summary'
    end

    module Types
      Entity = Java::OrgNeo4jDriverInternal::InternalEntity
      Node = Java::OrgNeo4jDriverInternal::InternalNode
      Path = Java::OrgNeo4jDriverInternal::InternalPath
      Relationship = Java::OrgNeo4jDriverInternal::InternalRelationship
    end
  end
end

Java::OrgNeo4jDriver::AuthTokens.singleton_class.prepend Neo4j::Driver::Ext::AuthTokens
Java::OrgNeo4jDriver::Bookmark.singleton_class.prepend Neo4j::Driver::Ext::Bookmark::ClassMethods
Java::OrgNeo4jDriver::Query.prepend Neo4j::Driver::Ext::Query
Java::OrgNeo4jDriverInternal::InternalBookmark.include Neo4j::Driver::Ext::Bookmark::InstanceMethods
Java::OrgNeo4jDriverInternal::InternalEntity.include Neo4j::Driver::Ext::InternalEntity
Java::OrgNeo4jDriverInternal::InternalNode.prepend Neo4j::Driver::Ext::InternalNode
Java::OrgNeo4jDriverInternal::InternalPath.include Neo4j::Driver::Ext::StartEndNaming
Java::OrgNeo4jDriverInternal::InternalPath::SelfContainedSegment.include Neo4j::Driver::Ext::StartEndNaming
Java::OrgNeo4jDriverInternal::InternalRecord.prepend Neo4j::Driver::Ext::InternalRecord
Java::OrgNeo4jDriverInternal::InternalRelationship.prepend Neo4j::Driver::Ext::InternalRelationship
Java::OrgNeo4jDriverInternal::InternalResult.prepend Neo4j::Driver::Ext::InternalResult
Java::OrgNeo4jDriverInternal::InternalSession.prepend Neo4j::Driver::Ext::InternalSession
Java::OrgNeo4jDriverInternal::InternalTransaction.prepend Neo4j::Driver::Ext::InternalTransaction
Java::OrgNeo4jDriverInternalSummary::InternalResultSummary.prepend Neo4j::Driver::Ext::Internal::Summary::InternalResultSummary
Java::OrgNeo4jDriverInternalValue::ValueAdapter.include Neo4j::Driver::Ext::RubyConverter
Java::OrgNeo4jDriverExceptions::Neo4jException.include Neo4j::Driver::Ext::ExceptionMapper