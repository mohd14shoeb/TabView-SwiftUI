//
//  MacrosRowView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import SwiftUI

struct MacrosRowView: View {
    
    // MARK: Private properties
    @ObservedObject private var viewModel: MacrosRowViewModel
    
    // MARK: Initilizer
    init(model: MacrosRowViewModel) {
        self.viewModel = model
    }
    
    // MARK: Body
    var body: some View {
        let model = self.viewModel.getModelProperties(model: self.viewModel.model,
                                                      currentIndex: self.viewModel.currentTab)
        VStack(alignment: .center, spacing: 2) {
            HStack() {
                VStack(alignment: .leading) {
                    Text(model.title).lineLimit(1).padding(.trailing, 10)
                        .font(Font.system(size: 15))
                    Spacer().frame(height: 4)
                    Text(model.decription).lineLimit(1)
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.black).opacity(0.9)
                }
                .foregroundColor(Color.black)
                Spacer()
                macrosListEditButtonSubView
            }
            Divider()
                .frame(height: 1)
                .background(Color.gray).opacity(0.4)
                .padding(.top, 6)
        }.padding(.horizontal)
    }
    
    // MARK: EditButtonSubView
    private var macrosListEditButtonSubView: some View {
        Button(action: {
            self.viewModel.showPopover = true
        }) {
            Image(systemName: "ellipsis").padding(.bottom, 6)
                .foregroundColor(.gray)
                .frame(width: 40).padding([.trailing], -8)
        }
        .popover(isPresented: self.$viewModel.showPopover,
                 attachmentAnchor: .rect(.rect(CGRect(x: 8,
                                                      y: 2,
                                                      width: 0,
                                                      height: 0))),
                 arrowEdge: .bottom) {
            VStack(alignment: .center, spacing: 2) {
                HStack {
                    Button("Edit") {
                        self.viewModel.buttonTapOptions(isShowPopover: false,
                                                        oprationType: .edit,
                                                        model: self.viewModel.model)
                    }.padding([.top, .bottom], 10)
                    Spacer()
                    Image(systemName: "pencil")
                        .resizable().frame(width: 16, height: 16)
                }.foregroundColor(Color.screenBackgroundColor)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 1) {
                        self.viewModel.buttonTapOptions(isShowPopover: false,
                                                        oprationType: .edit,
                                                        model: self.viewModel.model)
                    }
                Divider()
                    .frame(height: 1)
                    .background(Color.gray).opacity(0.3)
                HStack {
                    Button("Delete") {
                        self.viewModel.buttonTapOptions(isShowPopover: false,
                                                        oprationType: .delete,
                                                        model: self.viewModel.model)
                    }.padding([.top, .bottom], 10)
                    Spacer()
                    Image(systemName: "xmark.bin")
                        .resizable().frame(width: 16, height: 16)
                }.foregroundColor(Color.screenBackgroundColor)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.viewModel.buttonTapOptions(isShowPopover: false,
                                                        oprationType: .delete,
                                                        model: self.viewModel.model)
                    }
                
            }.padding(.horizontal, 20)
                .frame(width: 150, height: 100)
                .presentationCompactAdaptation(.popover)
        }
    }
    
}

// MARK: MacrosRowView Previews
struct MacrosRowView_Previews: PreviewProvider {
    static var previews: some View {
        let model = MacrosModel(gender: "M",
                                name: Name(title: "",
                                           first: "",
                                           last: ""),
                                location: Location(street: Street(number: 0,
                                                                  name: ""),
                                                   city: "ssjhdsj",
                                                   state: "sdfsdf",
                                                   country: "asdsa"),
                                email: "xyz@gmail.com",
                                phone: "",
                                cell: "",
                                nat: "")
        let macrViewModel = MacrosRowViewModel(model: model,
                                               currentTab: 0) { _, _  in }
        MacrosRowView(model: macrViewModel)
    }
}
