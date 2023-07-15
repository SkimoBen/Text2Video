//
//  ContentView.swift
//  Text2Video
//
//  Created by Ben Pearman on 2023-07-15.
//

import SwiftUI

struct ContentView: View {
    @State var promptState: String = ""
    @State var heightState: String = "320"
    @State var widthState: String = "576"
    @State var samplesState: String = "40"
    @State var framesState: String = "36"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Prompt")
                .padding([.leading, .trailing], 20)
            
            TextField(text: $promptState) {
                
            }
            .frame(minHeight: 100)
            .background(.clear)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .padding([.leading, .trailing], 20)
            
            HStack {
                VStack {
                    Text("Height")
                        .padding([.leading, .trailing], 20)
                    
                    TextField("Height", text: $heightState)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 50, minHeight: 30)
                        .background(.clear)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding([.leading, .trailing], 20)
                }
               
                VStack {
                    Text("Width")
                        .padding([.leading, .trailing], 20)
                    
                    TextField("Width", text: $widthState)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 50, minHeight: 30)
                        .background(.clear)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding([.leading, .trailing], 20)
                }
            }
            
            
            
            Text("Number of Inference Steps")
                .padding([.leading, .trailing], 20)
            
            TextField("Number of Inference Steps", text: $samplesState)
                .keyboardType(.numberPad)
                .frame(maxWidth: 50, minHeight: 30)
                .background(.clear)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding([.leading, .trailing], 20)
            
            Text("Number of Frames")
                .padding([.leading, .trailing], 20)
            
            TextField("Number of Frames", text: $framesState)
                .keyboardType(.numberPad)
                .frame(maxWidth: 50, minHeight: 30)
                .background(.clear)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding([.leading, .trailing], 20)
            
           
            Button(action: {
                //update the variables with the state values
                prompt = promptState
                height = Int(heightState)!
                width = Int(widthState)!
                num_inference_steps = Int(samplesState)!
                frames = Int(framesState)!
                
                //update the dictionary with the values
                updateCerebriumJSONObject()
                
                //send it
                sendIt()
                
            }, label: {
                Text("Generate Video")
                    .frame(width: 300, height: 10)
                    .font(.body)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue.opacity(1))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            })
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


