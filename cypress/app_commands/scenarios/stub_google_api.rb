# frozen_string_literal: true

plus_code_retriever = double('PlusCodeRetriever')

allow(PlusCodeRetriever).to receive(:new).with(latitude: command_options['latitude'], longitude: command_options['longitude']).and_return(plus_code_retriever)
allow(plus_code_retriever).to receive(:run).and_return('8GR5QJFG+57M')

nil