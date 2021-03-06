require 'takeaway'

describe 'takeaway' do

  menu = Menu.new
  order = Order
  sms_tool = FakeSms.new
  takeaway = Takeaway.new(menu, order, sms_tool)

  describe 'items can be added to menu' do
    it 'allows items to be added to menu' do
      menu1 = Menu.new
      expect(menu1.items).to be_empty
      menu1.add_items_from_hash(Menu::CHINESE_MENU_ITEMS)
      expect(menu1.items).to eq Menu::CHINESE_MENU_ITEMS
    end
  end

  describe 'displays menu' do
    it 'raises error if menu is empty' do
      expect { takeaway.print_menu }.to raise_error "No items added to menu"
    end

    it 'prints menu to STDout' do
      menu.add_items_from_hash(Menu::CHINESE_MENU_ITEMS)
      expect { takeaway.print_menu }.to output("Prawn Toast, price £4.50\nFried rice, price £3.00\nBeef Chow mein, price £6.00\nSalt and Pepper King Prawn, price £7.00\n").to_stdout
    end
  end

  describe 'order feature for available items' do
    it 'allows user to order some number of several available dishes' do
      menu.add_items_from_hash(Menu::INDIAN_MENU_ITEMS)
      expect(takeaway.order_item("Pilau Rice", 3)).to eq "3 x Pilau Rice sucessfully added"
      expect(takeaway.order_item("Tarka dal", 3)).to eq "3 x Tarka dal sucessfully added"
    end
  end

  describe 'order feature non available items' do
    it 'will not allow user to order items that are not on the menu' do
      expect { takeaway.order_item("Pizza", 3) }.to raise_error 'Sorry, we do not sell Pizza'
    end
  end

  describe 'user complete_order' do
    it 'confirms order empty if no items ordered' do
      takeaway1 = Takeaway.new
      expect { takeaway1.complete_order(2) }.to raise_error 'No items ordered yet!'
    end
    it 'allows user to verify order by checking user total against order total' do
      takeaway1 = Takeaway.new(menu, order)
      menu.add_items_from_hash(Menu::INDIAN_MENU_ITEMS)
      takeaway1.order_item("Pilau Rice", 3)
      takeaway1.order_item("Tarka dal", 3)
      takeaway1.order_item("Saag Paneer", 3)
      expect(takeaway1.complete_order(42.0)).to eq ["Message sent"]
    end
    it 'raises error if user suggested total does not match order total' do
      takeaway.order_item("Pilau Rice", 3)
      takeaway.order_item("Tarka dal", 3)
      expect { takeaway.complete_order(43) }.to raise_error "Total does not match current order, order not processed"
    end
    it 'sends test message confirmation to user' do
      takeaway3 = Takeaway.new(menu, order, sms_tool)
      takeaway3.order_item("Pilau Rice", 3)
      takeaway3.complete_order(9)
      expect(sms_tool.messages).to eq ["Message sent"]
    end
  end
end
