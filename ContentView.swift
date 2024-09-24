import SwiftUI
import Combine

// MARK: - Color Palette
extension Color {
    static let primaryColor = Color(red: 0.25, green: 0.47, blue: 0.85) // Blue
    static let secondaryColor = Color(red: 0.95, green: 0.77, blue: 0.06) // Yellow
    static let accentColor = Color(red: 0.95, green: 0.3, blue: 0.3) // Coral
    static let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95) // Light Gray
    static let cardBackgroundColor = Color.white
}

// MARK: - Data Models
struct Opportunity: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: Category
    let description: String
    let imageName: String
    var isStarred: Bool = false
    var timeSpent: Double = 0.0 // Time in hours
    var isCompleted: Bool = false
}

enum Category: String, CaseIterable, Codable {
    case volunteer = "Volunteer"
    case government = "Government"
}

class User: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var starredOpportunities: [UUID] = []
}

// MARK: - Sample Data
let sampleOpportunities: [Opportunity] = [
    // Volunteer Opportunities
    Opportunity(
        id: UUID(),
        title: "Park Clean-Up",
        category: .volunteer,
        description: "Join us in keeping our local parks pristine. Tasks include litter collection, planting trees, and maintaining trails. Your efforts help preserve natural beauty for everyone to enjoy.",
        imageName: "leaf.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Food Bank Assistance",
        category: .volunteer,
        description: "Help sort and distribute food to those in need. Your time can make a significant difference in ensuring that families receive nutritious meals.",
        imageName: "cart.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Community Gardening",
        category: .volunteer,
        description: "Participate in creating and maintaining community gardens. Grow fresh produce, beautify our neighborhood, and foster community spirit.",
        imageName: "sun.max.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Library Support",
        category: .volunteer,
        description: "Assist in organizing books, helping patrons, and managing library events. Support lifelong learning and literacy in our community.",
        imageName: "book.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Senior Center Activities",
        category: .volunteer,
        description: "Engage with seniors through various activities, including games, discussions, and outings. Your companionship can brighten their days.",
        imageName: "person.3.fill"
    ),
    
    // Government Opportunities
    Opportunity(
        id: UUID(),
        title: "Town Council Meeting",
        category: .government,
        description: "Attend town council meetings to stay informed and voice your opinions on local policies and developments. Shape the future of your community.",
        imageName: "building.2.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Public Hearing on Development",
        category: .government,
        description: "Participate in public hearings regarding new developments in the area. Provide feedback and engage with city planners to influence urban growth.",
        imageName: "mic.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Volunteer for Public Events",
        category: .government,
        description: "Assist in organizing and managing public events. Ensure events run smoothly and are enjoyable for all attendees.",
        imageName: "calendar.badge.plus"
    ),
    Opportunity(
        id: UUID(),
        title: "Community Safety Committee",
        category: .government,
        description: "Work with local law enforcement and community members to develop safety initiatives. Promote a secure and harmonious environment.",
        imageName: "shield.lefthalf.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Environmental Policy Advisory",
        category: .government,
        description: "Contribute to the creation and review of environmental policies. Advocate for sustainable practices and conservation efforts.",
        imageName: "leaf.arrow.circlepath"
    )
]

// MARK: - ViewModel
class OpportunityViewModel: ObservableObject {
    @Published var opportunities: [Opportunity] = sampleOpportunities
    @Published var user: User = User()
    
    // Star/Unstar Opportunity
    func toggleStar(for opportunity: Opportunity) {
        if let index = opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            opportunities[index].isStarred.toggle()
            if opportunities[index].isStarred {
                user.starredOpportunities.append(opportunity.id)
            } else {
                user.starredOpportunities.removeAll { $0 == opportunity.id }
            }
        }
    }
    
    // Track Time
    func addTime(for opportunity: Opportunity, hours: Double) {
        if let index = opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            opportunities[index].timeSpent += hours
        }
    }
    
    // Mark as Completed
    func markCompleted(for opportunity: Opportunity) {
        if let index = opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            opportunities[index].isCompleted = true
        }
    }
}

// MARK: - Main App Structure with TabView
struct ContentView: View {
    @StateObject private var viewModel = OpportunityViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(viewModel)
            
            StarredView()
                .tabItem {
                    Label("Starred", systemImage: "star.fill")
                }
                .environmentObject(viewModel)
            
            TrackingView()
                .tabItem {
                    Label("Tracking", systemImage: "clock.fill")
                }
                .environmentObject(viewModel)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
                .environmentObject(viewModel)
        }
        .accentColor(.primaryColor)
    }
}

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var selectedCategory: Category = .volunteer
    @Namespace private var animation
    
    var filteredOpportunities: [Opportunity] {
        viewModel.opportunities.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    // Header
                    Text("Local Opportunities")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.top, .horizontal])
                        .foregroundColor(.primaryColor)
                        .transition(.slide)
                    
                    // Category Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        selectedCategory = category
                                    }
                                }) {
                                    Text(category.rawValue)
                                        .fontWeight(selectedCategory == category ? .bold : .regular)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedCategory == category ? Color.primaryColor : Color.cardBackgroundColor)
                                                .shadow(color: selectedCategory == category ? Color.primaryColor.opacity(0.4) : Color.clear, radius: 5, x: 0, y: 5)
                                        )
                                        .foregroundColor(selectedCategory == category ? .white : .primaryColor)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                    
                    // Opportunities List
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredOpportunities) { opportunity in
                                NavigationLink(destination: OpportunityDetailView(opportunity: opportunity)) {
                                    OpportunityCardView(opportunity: opportunity)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.opacity)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - OpportunityCardView
struct OpportunityCardView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    let opportunity: Opportunity
    @State private var animate = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Icon
            Image(systemName: opportunity.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.accentColor)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.cardBackgroundColor)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                )
                .scaleEffect(animate ? 1.0 : 0.8)
                .opacity(animate ? 1.0 : 0.5)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: animate)
            
            // Text
            VStack(alignment: .leading, spacing: 5) {
                Text(opportunity.title)
                    .font(.headline)
                    .foregroundColor(.primaryColor)
                Text(opportunity.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondaryColor)
            }
            Spacer()
            
            // Star Button
            Button(action: {
                withAnimation {
                    viewModel.toggleStar(for: opportunity)
                }
            }) {
                Image(systemName: opportunity.isStarred ? "star.fill" : "star")
                    .foregroundColor(opportunity.isStarred ? .yellow : .gray)
                    .scaleEffect(opportunity.isStarred ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: opportunity.isStarred)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .onAppear {
            self.animate = true
        }
    }
}

// MARK: - OpportunityDetailView
struct OpportunityDetailView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var animate = false
    @State private var timeSpent: String = ""
    @State private var showAlert = false
    let opportunity: Opportunity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Icon
                Image(systemName: opportunity.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                    )
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animate)
                
                // Title
                Text(opportunity.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                    .animation(.none)
                
                // Category
                Text(opportunity.category.rawValue)
                    .font(.title3)
                    .foregroundColor(.secondaryColor)
                
                // Description
                Text(opportunity.description)
                    .font(.body)
                    .foregroundColor(.primaryColor)
                
                // Track Time Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Track Time Spent")
                        .font(.headline)
                        .foregroundColor(.primaryColor)
                    
                    HStack {
                        TextField("Hours", text: $timeSpent)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondaryColor, lineWidth: 1))
                        
                        Button(action: {
                            if let hours = Double(timeSpent) {
                                viewModel.addTime(for: opportunity, hours: hours)
                                timeSpent = ""
                                showAlert = true
                            }
                        }) {
                            Text("Add")
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.primaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(Double(timeSpent) == nil)
                    }
                }
                
                // Mark as Completed Button
                Button(action: {
                    withAnimation {
                        viewModel.markCompleted(for: opportunity)
                    }
                }) {
                    Text(opportunity.isCompleted ? "Completed ✅" : "Mark as Completed")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(opportunity.isCompleted ? Color.gray : Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: opportunity.isCompleted ? Color.clear : Color.primaryColor.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .disabled(opportunity.isCompleted)
                .padding(.top, 20)
                .scaleEffect(animate ? 1.0 : 0.8)
                .opacity(animate ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animate)
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Time added successfully!"), dismissButton: .default(Text("OK")))
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear {
            self.animate = true
        }
    }
}

// MARK: - StarredView
struct StarredView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var starredOpportunities: [Opportunity] {
        viewModel.opportunities.filter { viewModel.user.starredOpportunities.contains($0.id) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                if starredOpportunities.isEmpty {
                    VStack {
                        Spacer()
                        Text("No starred opportunities yet.")
                            .font(.headline)
                            .foregroundColor(.secondaryColor)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(starredOpportunities) { opportunity in
                                NavigationLink(destination: OpportunityDetailView(opportunity: opportunity)) {
                                    OpportunityCardView(opportunity: opportunity)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.opacity)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarTitle("Starred", displayMode: .inline)
        }
    }
}

// MARK: - TrackingView
struct TrackingView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.opportunities.isEmpty {
                    VStack {
                        Spacer()
                        Text("No activities to track.")
                            .font(.headline)
                            .foregroundColor(.secondaryColor)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.opportunities) { opportunity in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(opportunity.title)
                                        .font(.headline)
                                        .foregroundColor(.primaryColor)
                                    Text(opportunity.category.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.secondaryColor)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(String(format: "%.2f hrs", opportunity.timeSpent))
                                        .font(.subheadline)
                                        .foregroundColor(.primaryColor)
                                    Text(opportunity.isCompleted ? "Completed ✅" : "In Progress")
                                        .font(.caption)
                                        .foregroundColor(opportunity.isCompleted ? .green : .orange)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Tracking", displayMode: .inline)
        }
    }
}

// MARK: - AccountView
struct AccountView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var usernameInput: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.primaryColor)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.cardBackgroundColor)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                        )
                        .scaleEffect(1.0)
                        .opacity(1.0)
                        .animation(.easeInOut(duration: 0.5), value: true)
                    
                    if viewModel.user.isLoggedIn {
                        Text("Hello, \(viewModel.user.username)!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColor)
                        
                        Button(action: {
                            withAnimation {
                                viewModel.user.isLoggedIn = false
                                viewModel.user.username = ""
                            }
                        }) {
                            Text("Logout")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.primaryColor.opacity(0.4), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 15) {
                            TextField("Username", text: $usernameInput)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondaryColor, lineWidth: 1))
                            
                            Button(action: {
                                if !usernameInput.isEmpty {
                                    withAnimation {
                                        viewModel.user.isLoggedIn = true
                                        viewModel.user.username = usernameInput
                                        usernameInput = ""
                                    }
                                } else {
                                    showAlert = true
                                }
                            }) {
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.primaryColor.opacity(0.4), radius: 5, x: 0, y: 5)
                            }
                            .disabled(usernameInput.isEmpty)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Error"), message: Text("Please enter a username."), dismissButton: .default(Text("OK")))
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Account", displayMode: .inline)
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(OpportunityViewModel())
    }
}

struct StarredView_Previews: PreviewProvider {
    static var previews: some View {
        StarredView()
            .environmentObject(OpportunityViewModel())
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
            .environmentObject(OpportunityViewModel())
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(OpportunityViewModel())
    }
}

struct OpportunityCardView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunityCardView(opportunity: sampleOpportunities[0])
            .environmentObject(OpportunityViewModel())
    }
}

struct OpportunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunityDetailView(opportunity: sampleOpportunities[0])
            .environmentObject(OpportunityViewModel())
    }
}
