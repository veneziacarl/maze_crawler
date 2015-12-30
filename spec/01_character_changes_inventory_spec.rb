require_relative '../file_helper'

RSpec.describe Character do
  let(:player) {Character.new({type: :player, max_hp: 14, str: 12})}
  let(:item) {Item.new({hp_mod: 2, str_mod: 2})}

  it 'is a Character class' do
    # player = FactoryGirl.create(:character)
    expect(player.class).to eq(Character)
  end

  it 'can add items' do
    player.add_inventory(item)

    expect(player.max_hp).to eq(16)
    expect(player.current_hp).to eq(16)
    expect(player.str).to eq(14)
  end

  it 'can remove items' do
    player.add_inventory(item)

    expect(player.max_hp).to eq(16)
    expect(player.current_hp).to eq(16)
    expect(player.str).to eq(14)

    player.remove_inventory(item)

    expect(player.max_hp).to eq(14)
    expect(player.current_hp).to eq(14)
    expect(player.str).to eq(12)
  end

  it 'can change hp' do
    player.hp_change(-2)
    expect(player.max_hp).to eq(14)
    expect(player.current_hp).to eq(12)

    player.hp_change(5)
    expect(player.max_hp).to eq(14)
    expect(player.current_hp).to eq(14)
  end

  it 'can roll damage' do
    10.times do
      expect(player.roll_damage).to be <= 9
      expect(player.roll_damage).to be >= 4
    end
  end
end
