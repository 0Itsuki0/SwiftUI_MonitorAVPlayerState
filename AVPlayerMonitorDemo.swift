
import SwiftUI
import AVKit

struct AVPlayerMonitor: View {
    
    private let videos: [(String, String)] = [("video1", "mp4"), ("video2", "mov")]
    
    @State private var player: AVPlayer?
    @State private var selectedVideoIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 36) {

                HStack(spacing: 16) {
                    Button(action: {
                        let videoIndex = selectedVideoIndex == 0 ? 1 : 0
                        if let url = url(videos[videoIndex]) {
                            player?.replaceCurrentItem(with: .init(url: url))
                            self.selectedVideoIndex = videoIndex
                        }
                    }, label: {
                        Text("Change Item")
                    })
                    
                    Divider()
                    
                    HStack(spacing: 0) {
                        Text("Volume")
                            .font(.headline)
                        Spacer()
                            .frame(width: 16)
                                                
                        Button(action: {
                            let current = player?.volume ?? 1.0
                            player?.volume = max(current - 0.1, 0)
                            
                        }, label: {
                            Image(systemName: "minus")
                                .frame(maxHeight: .infinity)
                        })
                        .buttonBorderShape(.circle)
                        
                        Button(action: {
                            let current = player?.volume ?? 1.0
                            player?.volume = min(current + 0.1, 1.0)
                        }, label: {
                            Image(systemName: "plus")
                                .frame(maxHeight: .infinity)
                        })
                        .buttonBorderShape(.circle)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                VideoPlayer(player: player)
                    .frame(height: 240)
                
                if let player {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Player")
                            .font(.headline)
                        Text(String("Status: \(player.timeControlStatus.displayString)"))
                        Text(String("Playback rate: \(String(format: "%.2f", player.rate))"))
                        Text(String("Volume: \(String(format: "%.2f", player.volume))"))
                        
                        if let playerItem = player.currentItem {
                            Divider()
                            Text("Current Player Item")
                                .font(.headline)
                            
                            Text(String("Status: \(playerItem.status.displayString)"))
                            Text(String("Duration: \(String(format: "%.2f", playerItem.duration.seconds)) sec"))
                        }
    
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 4).fill(.clear).stroke(.black, style: .init(lineWidth: 1)))
                }
                
            }
            .buttonStyle(.glassProminent)
            .padding()
            .padding(.vertical, 48)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.yellow.opacity(0.2))
            .onAppear {
                AVPlayer.isObservationEnabled = true
                if let url = url(videos[selectedVideoIndex]) {
                    player = .init(url: url)
                }
            }
            .navigationTitle("Monitor AVPlayer")
            .navigationSubtitle("Status, Rate, Volume, Item")

        }
    }
    
    private func url(_ nameExtension: (String, String)) -> URL? {
        return Bundle.main.url(forResource: nameExtension.0, withExtension: nameExtension.1)
    }
}


extension AVPlayerItem.Status {
    var displayString: String {
        switch self {
            
        case .unknown:
            "Unknown"
        case .readyToPlay:
            "Ready"
        case .failed:
            "Failed"
        @unknown default:
            "Unknown"
        }
    }
}

extension AVPlayer.TimeControlStatus {
    var displayString: String {
        switch self {
            
        case .paused:
            "Paused"
        case .waitingToPlayAtSpecifiedRate:
            "Waiting"
        case .playing:
            "Playing"
        @unknown default:
            "Unknwon"
        }
    }
}
