module InvoicePrinter
  # Invoice and receipt representation
  #
  # Example:
  #
  #   invoice = InvoicePrinter::Document.new(
  #     number: '198900000001',
  #     provider_name: 'Business s.r.o.',
  #     provider_tax_id: '56565656',
  #     provider_tax_id2: '465454',
  #     provider_street: 'Rolnicka',
  #     provider_street_number: '1',
  #     provider_postcode: '747 05',
  #     provider_city: 'Opava',
  #     provider_city_part: 'Katerinky',
  #     provider_extra_address_line: 'Czech Republic',
  #     purchaser_name: 'Adam',
  #     purchaser_tax_id: '',
  #     purchaser_tax_id2: '',
  #     purchaser_street: 'Ostravska',
  #     purchaser_street_number: '1',
  #     purchaser_postcode: '747 70',
  #     purchaser_city: 'Opava',
  #     purchaser_city_part: '',
  #     purchaser_extra_address_line: '',
  #     issue_date: '19/03/3939',
  #     due_date: '19/03/3939',
  #     subtotal: '$ 150',
  #     tax: '$ 50',
  #     total: '$ 200',
  #     bank_account_number: '156546546465',
  #     account_iban: 'IBAN464545645',
  #     account_swift: 'SWIFT5456',
  #     items: [
  #       InvoicePrinter::Document::Item.new,
  #       InvoicePrinter::Document::Item.new
  #     ],
  #     note: 'A note at the end.'
  #   )
  #
  # +amount should equal the sum of all item's +amount+,
  # but this is not enforced.
  class Document
    class InvalidInput < StandardError; end

    attr_reader :number,
                # Provider fields
                :provider_name,
                :provider_tax_id,
                :provider_tax_id2,
                # Provider address fields
                :provider_street,
                :provider_street_number,
                :provider_postcode,
                :provider_city,
                :provider_city_part,
                :provider_extra_address_line,
                # Purchaser fields
                :purchaser_name,
                :purchaser_tax_id,
                :purchaser_tax_id2,
                # Purchaser address fields
                :purchaser_street,
                :purchaser_street_number,
                :purchaser_postcode,
                :purchaser_city,
                :purchaser_city_part,
                :purchaser_extra_address_line,
                :issue_date,
                :due_date,
                # Account details
                :subtotal,
                :tax,
                :tax2,
                :tax3,
                :total,
                :bank_account_number,
                :account_details,
                :account_iban,
                :account_swift,
                # Collection of InvoicePrinter::Invoice::Items
                :items,
                :note

    class << self
      def from_json(json)
        new(
          number:                       json['number'],
          provider_name:                json['provider_name'],
          provider_tax_id:              json['provider_tax_id'],
          provider_tax_id2:             json['provider_tax_id2'],
          provider_street:              json['provider_street'],
          provider_street_number:       json['provider_street_number'],
          provider_postcode:            json['provider_postcode'],
          provider_city:                json['provider_city'],
          provider_city_part:           json['provider_city_part'],
          provider_extra_address_line:  json['provider_extra_address_line'],
          purchaser_name:               json['purchaser_name'],
          purchaser_tax_id:             json['purchaser_tax_id'],
          purchaser_tax_id2:            json['purchaser_tax_id2'],
          purchaser_street:             json['purchaser_street'],
          purchaser_street_number:      json['purchaser_street_number'],
          purchaser_postcode:           json['purchaser_postcode'],
          purchaser_city:               json['purchaser_city'],
          purchaser_city_part:          json['purchaser_city_part'],
          purchaser_extra_address_line: json['purchaser_extra_address_line'],
          issue_date:                   json['issue_date'],
          due_date:                     json['due_date'],
          subtotal:                     json['subtotal'],
          tax:                          json['tax'],
          tax2:                         json['tax2'],
          tax3:                         json['tax3'],
          total:                        json['total'],
          bank_account_number:          json['bank_account_number'],
          account_details:              json['account_details'],
          account_iban:                 json['account_iban'],
          account_swift:                json['account_swift'],
          note:                         json['note'],

          items:                        (json['items'] || []).map { |item_json| Item.from_json(item_json) }
        )
      end
    end

    def initialize(number:                       nil,
                   provider_name:                nil,
                   provider_tax_id:              nil,
                   provider_tax_id2:             nil,
                   provider_street:              nil,
                   provider_street_number:       nil,
                   provider_postcode:            nil,
                   provider_city:                nil,
                   provider_city_part:           nil,
                   provider_extra_address_line:  nil,
                   purchaser_name:               nil,
                   purchaser_tax_id:             nil,
                   purchaser_tax_id2:            nil,
                   purchaser_street:             nil,
                   purchaser_street_number:      nil,
                   purchaser_postcode:           nil,
                   purchaser_city:               nil,
                   purchaser_city_part:          nil,
                   purchaser_extra_address_line: nil,
                   issue_date:                   nil,
                   due_date:                     nil,
                   subtotal:                     nil,
                   tax:                          nil,
                   tax2:                         nil,
                   tax3:                         nil,
                   total:                        nil,
                   bank_account_number:          nil,
                   account_details:              nil,
                   account_iban:                 nil,
                   account_swift:                nil,
                   items:                        nil,
                   note:                         nil)

      @number                       = String(number)
      @provider_name                = String(provider_name)
      @provider_tax_id              = String(provider_tax_id)
      @provider_tax_id2             = String(provider_tax_id2)
      @provider_street              = String(provider_street)
      @provider_street_number       = String(provider_street_number)
      @provider_postcode            = String(provider_postcode)
      @provider_city                = String(provider_city)
      @provider_city_part           = String(provider_city_part)
      @provider_extra_address_line  = String(provider_extra_address_line)
      @purchaser_name               = String(purchaser_name)
      @purchaser_tax_id             = String(purchaser_tax_id)
      @purchaser_tax_id2            = String(purchaser_tax_id2)
      @purchaser_street             = String(purchaser_street)
      @purchaser_street_number      = String(purchaser_street_number)
      @purchaser_postcode           = String(purchaser_postcode)
      @purchaser_city               = String(purchaser_city)
      @purchaser_city_part          = String(purchaser_city_part)
      @purchaser_extra_address_line = String(purchaser_extra_address_line)
      @issue_date                   = String(issue_date)
      @due_date                     = String(due_date)
      @subtotal                     = String(subtotal)
      @tax                          = String(tax)
      @tax2                         = String(tax2)
      @tax3                         = String(tax3)
      @total                        = String(total)
      @bank_account_number          = String(bank_account_number)
      @account_details              = String(account_details)
      @account_iban                 = String(account_iban)
      @account_swift                = String(account_swift)
      @items                        = items
      @note                         = String(note)

      raise InvalidInput, 'items are not only a type of InvoicePrinter::Document::Item' \
        unless @items.select{ |i| !i.is_a?(InvoicePrinter::Document::Item) }.empty?
    end

    def to_h
      {
        'number':                       @number,
        'provider_name':                @provider_name,
        'provider_tax_id':              @provider_tax_id,
        'provider_tax_id2':             @provider_tax_id2,
        'provider_street':              @provider_street,
        'provider_street_number':       @provider_street_number,
        'provider_postcode':            @provider_postcode,
        'provider_city':                @provider_city,
        'provider_city_part':           @provider_city_part,
        'provider_extra_address_line':  @provider_extra_address_line,
        'purchaser_name':               @purchaser_name,
        'purchaser_tax_id':             @purchaser_tax_id,
        'purchaser_tax_id2':            @purchaser_tax_id2,
        'purchaser_street':             @purchaser_street,
        'purchaser_street_number':      @purchaser_street_number,
        'purchaser_postcode':           @purchaser_postcode,
        'purchaser_city':               @purchaser_city,
        'purchaser_city_part':          @purchaser_city_part,
        'purchaser_extra_address_line': @purchaser_extra_address_line,
        'issue_date':                   @issue_date,
        'due_date':                     @due_date,
        'subtotal':                     @subtotal,
        'tax':                          @tax,
        'tax2':                         @tax2,
        'tax3':                         @tax3,
        'total':                        @total,
        'bank_account_number':          @bank_account_number,
        'account_details':              @account_details,
        'account_iban':                 @account_iban,
        'account_swift':                @account_swift,
        'items':                        @items.map(&:to_h),
        'note':                         @note
      }
    end

    def to_json
      to_h.to_json
    end
  end
end
