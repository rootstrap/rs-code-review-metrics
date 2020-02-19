FactoryBot.define do
  factory :user_payload, class: Hash do
    id { 1 }
    node_id { 'MDQ6NlcjE4' }
    login { 'heptacat' }
    type { 'User' }

    initialize_with do
      {
        id: id,
        node_id: node_id,
        login: login,
        type: type
      }.deep_stringify_keys
    end
  end

  factory :repository_payload, class: Hash do
    id { 186_853_002 }
    node_id { 'MDEwOlJlcG9zaXRvcnkxODY4NTMwMDI=' }
    name { 'Pull Hello-World' }
    full_name { 'Codertocat/Hello-World' }

    association :pull_request_owner,
                factory: :user_payload,
                id: 21_031_067,
                node_id: 'MDQ6VXNlcjIxMDMxMDY3',
                login: 'Codertocat'

    initialize_with do
      {
        id: id,
        node_id: node_id,
        name: name,
        full_name: full_name,
        owner: pull_request_owner
      }.deep_stringify_keys
    end
  end

  factory :pull_request_payload, class: Hash do
    id      { 1001 }
    number  { 2 }
    state   { 'open' }
    node_id { 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3' }
    title   { 'Pull Request 2' }
    locked  { false }
    merged  { false }
    draft   { false }

    association :pull_request_owner,
                factory: :user_payload,
                id: 21_031_067,
                node_id: 'MDQ6VXNlcjIxMDMxMDY3',
                login: 'Codertocat'

    association :repository, factory: :repository_payload

    initialize_with do
      {
        id: id,
        number: number,
        state: state,
        node_id: node_id,
        title: title,
        locked: locked,
        merged: merged,
        draft: draft,
        user: pull_request_owner,
        repository: repository
      }.deep_stringify_keys
    end
  end

  factory :pull_request_review_comment_payload, class: Hash do
    id { 1001 }
    node_id { 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3' }
    pull_request_review_id { 1002 }
    body { 'You might need to fix this.' }

    association :comment_owner,
                factory: :user_payload,
                id: 21_031_067,
                node_id: 'MDQ6VXNlcjIxMDMxMDY3',
                login: 'Codertocat'

    initialize_with do
      {
        id: id,
        node_id: node_id,
        pull_request_review_id: pull_request_review_id,
        user: comment_owner,
        body: body
      }.deep_stringify_keys
    end
  end

  factory :repository_event_payload, class: Hash do
    action { 'created' }

    association :repository, factory: :repository_payload

    initialize_with do
      {
        action: action,
        repository: repository
      }.deep_stringify_keys
    end
  end

  factory :pull_request_event_payload, class: Hash do
    action { 'opened' }
    number { 2 }

    requested_reviewer { nil }

    association :pull_request, factory: :pull_request_payload

    initialize_with do
      {
        action: action,
        number: number,
        pull_request: pull_request
      }.tap { |payload|
        payload['requested_reviewer'] = requested_reviewer unless requested_reviewer.nil?
      }.deep_stringify_keys
    end
  end

  factory :pull_request_review_event_payload, class: Hash do
    action { 'submitted' }
    id { 237_895_671 }
    node_id { 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3MjM3ODk1Njcx' }
    state { 'commented' }

    association :review_owner,
                factory: :user_payload,
                id: 21_031_067,
                node_id: 'MDQ6VXNlcjIxMDMxMDY3',
                login: 'Codertocat'

    association :pull_request, factory: :pull_request_payload

    association :repository, factory: :repository_payload

    trait :submitted do
      action { 'submitted' }
    end

    trait :edited do
      action { 'edited' }
    end

    trait :dismissed do
      action { 'dismissed' }
    end

    initialize_with do
      {
        action: action,
        state: state,
        review: {
          id: id,
          node_id: node_id,
          user: review_owner
        },
        pull_request: pull_request,
        repository: repository
      }.deep_stringify_keys
    end
  end

  factory :pull_request_review_comment_event_payload, class: Hash do
    action { 'created' }

    association :comment, factory: :pull_request_review_comment_payload

    association :pull_request, factory: :pull_request_payload

    changes { { body: 'Please fix this.' } }

    initialize_with do
      {
        action: action,
        comment: comment,
        pull_request: pull_request,
        changes: changes
      }.deep_stringify_keys
    end
  end
end
