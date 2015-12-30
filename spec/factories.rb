FactoryGirl.define do
  factory :character do
    attributes = {type: :player, max_hp: 12, str: 12}

    factory :monster do
      attributes = {type: :monster, max_hp: 12, str: 12}
    end
  end

  factory :item do
    item_attributes = {hp_mod: 2, str_mod: 2}
  end
end
