module Processors
  class JiraProjectBoardUpdater < BaseService
    def initialize(jira_board)
      @jira_board = jira_board
    end

    def call
      return if board_to_update.nil?

      board_update!(@jira_board, board_to_update.first)
    end

    private

    def board_to_update
      JiraClient::Repository.new(@jira_board).board
    end

    def board_update!(board, board_fields)
      board.update!(
        jira_board_id: board_fields[:id],
        jira_self_url: board_fields[:self],
        board_type: board_fields[:type]
      )
    end
  end
end
