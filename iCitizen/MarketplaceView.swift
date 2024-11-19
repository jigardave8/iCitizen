//
//  MarketplaceView.swift
//  iCitizen
//
//  Created by BitDegree on 19/11/24.
//

import SwiftUI

struct MarketplaceView: View {
    @State private var listings = [
        Listing(id: UUID(), title: "Mountain Bike", description: "Used mountain bike in great condition.", price: 150.0, type: .sell, bids: [], tradeOptions: "Open to trading for electronics"),
        Listing(id: UUID(), title: "Smartphone", description: "Brand new smartphone, sealed pack.", price: 700.0, type: .auction, bids: [Bid(user: "Alice", amount: 600)], tradeOptions: ""),
        Listing(id: UUID(), title: "Gaming Console", description: "Looking to trade for a smartphone.", price: nil, type: .trade, bids: [], tradeOptions: "Open to trading for smartphones")
    ]
    
    @State private var isAddingListing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    Text("Marketplace")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    // Add Listing Button
                    Button(action: {
                        isAddingListing.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add New Listing")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $isAddingListing) {
                        AddListingView(listings: $listings)
                    }
                    
                    // Listings
                    ForEach(listings) { listing in
                        ListingCard(listing: listing)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Buy/Sell/Trade")
        }
    }
}

// MARK: - Listing Model
enum ListingType {
    case sell, trade, auction
}

struct Listing: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let price: Double?
    let type: ListingType
    var bids: [Bid]
    let tradeOptions: String
}

struct Bid: Identifiable {
    let id = UUID()
    let user: String
    let amount: Double
}

// MARK: - Listing Card View
struct ListingCard: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(listing.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                if listing.type == .auction {
                    Text("Auction")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .padding(6)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                } else if listing.type == .sell {
                    Text("For Sale")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                } else if listing.type == .trade {
                    Text("For Trade")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                        .padding(6)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Text(listing.description)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            if let price = listing.price {
                Text("Price: $\(price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if listing.type == .auction && !listing.bids.isEmpty {
                Text("Highest Bid: \(listing.bids.max(by: { $0.amount < $1.amount })?.amount ?? 0, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if listing.type == .trade {
                Text("Trade Options: \(listing.tradeOptions)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                // Action to bid, buy, or trade
            }) {
                Text(listing.type == .sell ? "Buy Now" : (listing.type == .auction ? "Place Bid" : "Propose Trade"))
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(listing.type == .sell ? Color.green : (listing.type == .auction ? Color.orange : Color.purple))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}

// MARK: - Add Listing View
struct AddListingView: View {
    @Binding var listings: [Listing]
    @State private var title = ""
    @State private var description = ""
    @State private var price: String = ""
    @State private var selectedType: ListingType = .sell
    @State private var tradeOptions = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Item Title", text: $title)
                TextField("Description", text: $description)
                if selectedType != .trade {
                    TextField("Price (Optional)", text: $price)
                        .keyboardType(.decimalPad)
                }
                Picker("Listing Type", selection: $selectedType) {
                    Text("Sell").tag(ListingType.sell)
                    Text("Trade").tag(ListingType.trade)
                    Text("Auction").tag(ListingType.auction)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedType == .trade {
                    TextField("Trade Options (e.g., 'Open to trading for...')", text: $tradeOptions)
                }
                
                Button(action: {
                    let newListing = Listing(
                        id: UUID(),
                        title: title,
                        description: description,
                        price: Double(price) ?? nil,
                        type: selectedType,
                        bids: [],
                        tradeOptions: tradeOptions
                    )
                    listings.append(newListing)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Listing")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("New Listing")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
