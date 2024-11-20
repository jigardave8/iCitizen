//
//  MarketplaceView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//


import SwiftUI

// Model for Listing Details
struct MarketplaceListing: Identifiable {
    var id: Int
    var title: String
    var price: Double
    var image: String
    var description: String
    var category: String
    var location: String
    var status: ListingStatus
    var createdAt: Date
    var seller: Seller
    var bids: [Bid]
    var auctionStartDate: Date?
    var auctionEndDate: Date?
    var isFavorited: Bool
    var currentBid: Double
}


struct Seller {
    var name: String
    var rating: Double
    var joinedDate: Date
}

struct Bid {
    var id: Int
    var amount: Double
    var bidder: String
    var timestamp: Date
}

enum ListingStatus: String {
    case auction = "Auction"
    case available = "Available"
}

// Detail Row View
struct DetailRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

// Listing Detail View
struct ListingDetailView: View {
    @Binding var listing: MarketplaceListing
    @State private var showContactSheet = false
    @State private var showPurchaseConfirmation = false
    @State private var isFavorited: Bool
    @State private var currentBidAmount: Double
    @State private var biddingStatus: String
    @Environment(\.dismiss) var dismiss
    
    init(listing: Binding<MarketplaceListing>) {
        _listing = listing
        _isFavorited = State(initialValue: listing.wrappedValue.isFavorited)
        _currentBidAmount = State(initialValue: listing.wrappedValue.currentBid)
        _biddingStatus = State(initialValue: listing.wrappedValue.status == .auction ? "Open" : "Not Available")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image
                Image(listing.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                
                // Title and Price
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(listing.title)
                            .font(.title)
                            .bold()
                        Spacer()
                        Button(action: { isFavorited.toggle() }) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .foregroundColor(isFavorited ? .red : .gray)
                        }
                    }
                    
                    Text("$\(Int(listing.currentBid))")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .padding(.horizontal)
                
                // Details
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Category", value: listing.category)
                    DetailRow(title: "Location", value: listing.location)
                    DetailRow(title: "Status", value: listing.status.rawValue)
                    DetailRow(title: "Posted", value: listing.createdAt.formatted())
                    
                    // Auction Specific
                    if listing.status == .auction {
                        DetailRow(title: "Auction Start", value: listing.auctionStartDate?.formatted() ?? "N/A")
                        DetailRow(title: "Auction End", value: listing.auctionEndDate?.formatted() ?? "N/A")
                    }
                }
                .padding(.horizontal)
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    Text(listing.description)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Seller Information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Seller Information")
                        .font(.headline)
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(listing.seller.name)
                                .font(.subheadline)
                                .bold()
                            HStack {
                                Text("Rating:")
                                ForEach(0..<Int(listing.seller.rating)) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            Text("Member since \(listing.seller.joinedDate.formatted(.dateTime.month().year()))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Bidding Section
                if listing.status == .auction {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Current Bid: $\(Int(currentBidAmount))")
                            .font(.headline)
                        
                        // Time Left
                        if let auctionEndDate = listing.auctionEndDate {
                            let timeLeft = auctionEndDate.timeIntervalSinceNow
                            let daysLeft = max(0, Int(timeLeft) / (60 * 60 * 24))
                            Text("Time Left: \(daysLeft) days")
                                .font(.subheadline)
                        }
                        
                        // Bid Input Field
                        TextField("Enter your bid", value: $currentBidAmount, format: .number)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Button(action: placeBid) {
                            Text("Place Bid")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: { showPurchaseConfirmation.toggle() }) {
                        Text("Buy Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { showContactSheet.toggle() }) {
                        Text("Contact Seller")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showContactSheet) {
            ContactSellerView(seller: listing.seller)
        }
        .alert("Confirm Purchase", isPresented: $showPurchaseConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                // Handle purchase confirmation
            }
        } message: {
            Text("Are you sure you want to purchase this item for $\(Int(listing.currentBid))?")
        }
    }
    
    // Place Bid Functionality
    func placeBid() {
        guard currentBidAmount > listing.currentBid else { return }
        let newBid = Bid(id: listing.bids.count + 1, amount: currentBidAmount, bidder: "User123", timestamp: Date())
        listing.bids.append(newBid)
        listing.currentBid = currentBidAmount // Update the current bid
    }
}

// Marketplace View with Auctions
struct MarketplaceView: View {
    @State private var listings: [MarketplaceListing] = [
        MarketplaceListing(id: 1, title: "Item 1", price: 100, image: "item1", description: "Description for item 1", category: "Category 1", location: "Location 1", status: .auction, createdAt: Date(), seller: Seller(name: "John Doe", rating: 4.5, joinedDate: Date()), bids: [Bid(id: 1, amount: 120, bidder: "User123", timestamp: Date())], auctionStartDate: Date(), auctionEndDate: Date().addingTimeInterval(60*60*24*5), isFavorited: false, currentBid: 120),
        MarketplaceListing(id: 2, title: "Item 2", price: 150, image: "item2", description: "Description for item 2", category: "Category 2", location: "Location 2", status: .available, createdAt: Date(), seller: Seller(name: "Jane Smith", rating: 5.0, joinedDate: Date()), bids: [], auctionStartDate: nil, auctionEndDate: nil, isFavorited: false, currentBid: 150)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($listings) { $listing in
                    NavigationLink(destination: ListingDetailView(listing: $listing)) {
                        Text(listing.title)
                    }
                }
            }
            .navigationTitle("Marketplace")
        }
    }
}


// Contact Seller View (just a placeholder)
struct ContactSellerView: View {
    var seller: Seller
    
    var body: some View {
        VStack {
            Text("Contact \(seller.name)")
            // Add actual contact details here
        }
        .padding()
    }
}
