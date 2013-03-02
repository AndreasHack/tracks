# Get action count for the top 5 contexts
# If initialized with :running, then only active
# and visible contexts will be included.
module Stats
  class TopContextsQuery

    attr_reader :user, :running
    def initialize(user, running = nil)
      @user = user
      @running = running == :running
    end

    def result
      user.contexts.find_by_sql([sql, user.id])
    end

    private

    def sql
      query = "SELECT c.id AS id, c.name AS name, count(c.id) AS total "
      query << "FROM contexts c, todos t "
      query << "WHERE t.context_id=c.id "
      query << "AND t.user_id = ? "
      if running
        query << "AND t.completed_at IS NULL "
        query << "AND NOT c.state='hidden' "
      end
      query << "GROUP BY c.id, c.name "
      query << "ORDER BY total DESC "
      query << "LIMIT 5"
    end

  end
end