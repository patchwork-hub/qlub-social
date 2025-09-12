# frozen_string_literal: true

class AutoFollowDefaultAccountsService < BaseService
  DEFAULT_ACCOUNTS = [
    '@meadmin@qlub.social',
    '@qlub@qlub.social',
    '@kath@qlab.social',
  ].freeze

  def call(source_account)
    return unless source_account.local?

    DEFAULT_ACCOUNTS.each do |acct|
      follow_account(source_account, acct)
    end
  end

  private

  def follow_account(source_account, target_acct)
    target_account = ResolveAccountService.new.call(target_acct)
    return if target_account.nil?

    FollowService.new.call(source_account, target_account, bypass_locked: true, bypass_limit: true)
  rescue StandardError => e
    Rails.logger.error "Failed to auto-follow #{target_acct} for #{source_account.acct}: #{e.message}"
  end
end
