//
//  Model.swift
//  Text2Video
//
//  Created by Ben Pearman on 2023-07-15.
//

import Foundation
import Photos


var prompt: String = ""
var height: Int = 2
var width: Int = 2
var num_inference_steps: Int = 36
var frames: Int = 36

var cerebriumJSONObject: [String: Any] = [
    "prompt": "\(prompt)",
    "height": height,
    "width": width,
    "num_inference_steps": num_inference_steps,
    "num_frames": frames
   
]

func updateCerebriumJSONObject() {
    cerebriumJSONObject["prompt"] = prompt
    cerebriumJSONObject["height"] = height
    cerebriumJSONObject["width"] = width
    cerebriumJSONObject["num_inference_steps"] = num_inference_steps
    cerebriumJSONObject["num_frames"] = frames
}

//format the dictionary body into proper json for the HTTP request.
func makeJsonPayload(cerebriumJSONObject: [String: Any]) -> Data {
    //print("this is the jsonObject inside makeJsonPayload: \(openAiJsonObject)")
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: cerebriumJSONObject, options: .prettyPrinted)
        // jsonData is now the valid JSON payload
        
        
        return jsonData
    } catch {
        print("Error creating JSON payload: \(error)")
        return Data()
    }
    
}
var endPointURL: String = "https://run.cerebrium.ai/v2/p-xxxxxx/txt2video/predict"

func sendIt() {
    let decoder = JSONDecoder()
    
    guard let url = URL(string: endPointURL) else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("public-xxxxxxxxxxx", forHTTPHeaderField:"Authorization")
    request.addValue("application/json", forHTTPHeaderField:"Content-Type")
    request.httpBody = makeJsonPayload(cerebriumJSONObject: cerebriumJSONObject)
    request.timeoutInterval = 240
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error occurred: \(error)")
        } else if let data = data {
            do {
                let response = try decoder.decode(CerebriumResponse.self, from: data)
                let videoBase64 = response.video
                saveBase64StringToMP4(base64String: videoBase64, fileName: "Txt2Video\(UUID())")
            } catch {
                print("Error decoding response: \(error)")
            }
        }
    }
    task.resume()
}


struct CerebriumResponse: Codable {
    let runID: String
    let message: String
    let runTimeMs: Double
    let video: String
    
    enum CodingKeys: String, CodingKey {
        case runID = "run_id"
        case message = "message"
        case runTimeMs = "run_time_ms"
        case video = "result"
    }
}

func saveBase64StringToMP4(base64String: String, fileName: String) {
    guard let videoData = Data(base64Encoded: base64String) else {
        print("Failed to convert base64String to Data.")
        return
    }

    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("mp4")

    do {
        try videoData.write(to: fileURL, options: [.atomic])
        print("Video saved successfully to \(fileURL.absoluteString)")
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            if saved {
                print("The video was successfully saved in the photo library.")
            } else {
                print("Failed to save the video to the photo library: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    } catch {
        print("Failed to save video: \(error)")
    }
}








