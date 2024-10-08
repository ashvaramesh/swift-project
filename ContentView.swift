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
    case competition = "Competition"
    case research = "Research"
}

struct Badge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct StarredActivity: Identifiable {
    let id = UUID()
    let opportunity: Opportunity
}

class User: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var starredOpportunities: [UUID] = []
    @Published var skills: [String] = [] // Added for skill-based matching
    @Published var goals: [String] = [] // Added for personalized journeys
    @Published var badges: [Badge] = [] // Added for gamification
    @Published var totalImpact: Impact = Impact() // For impact metrics
    @Published var starredActivities: [StarredActivity] = [] // Starred Activities
}

struct Impact {
    var hoursVolunteered: Double = 0.0
    var peopleHelped: Int = 0
    var carbonFootprintReduced: Double = 0.0
}

// MARK: - Sample Data
let sampleOpportunities: [Opportunity] = [
    // Lake County Opportunities
    Opportunity(
        id: UUID(),
        title: "Lake County Forest Preserve Volunteer",
        category: .volunteer,
        description: "Assist with restoration projects, trail maintenance, and conservation efforts in the Lake County Forest Preserves. Perfect for students passionate about environmental protection.",
        imageName: "leaf.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Youth Leadership Program - Lake County Government",
        category: .government,
        description: "A leadership program focused on local government. Engage with Lake County officials and work on projects that impact local communities.",
        imageName: "building.2.crop.circle"
    ),
    Opportunity(
        id: UUID(),
        title: "Lake County Food Pantry Assistant",
        category: .volunteer,
        description: "Help organize, pack, and distribute food to families in need at local Lake County food pantries.",
        imageName: "cart.fill"
    ),

    // Illinois State Opportunities
    Opportunity(
        id: UUID(),
        title: "Illinois General Assembly Page for a Day",
        category: .government,
        description: "Experience a day in the Illinois General Assembly. Assist lawmakers and staff, and observe legislative proceedings in Springfield.",
        imageName: "megaphone.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Illinois State Science Fair",
        category: .competition,
        description: "Participate in this statewide science fair and present your research on a variety of STEM topics.",
        imageName: "flask.fill"
    ),
    
    // National Volunteer & Government Programs
    Opportunity(
        id: UUID(),
        title: "National Parks Service - Youth Conservation Corps",
        category: .volunteer,
        description: "A summer work program for students who want to help conserve America's national parks. Participants assist with trail maintenance and habitat preservation.",
        imageName: "leaf.arrow.triangle.circlepath"
    ),
    Opportunity(
        id: UUID(),
        title: "Congressional Award Program",
        category: .government,
        description: "Earn a Congressional Award by setting and achieving personal goals in volunteer service, personal development, physical fitness, and expedition/exploration.",
        imageName: "star"
    ),

    // National Competitions
    Opportunity(
        id: UUID(),
        title: "Regeneron Science Talent Search",
        category: .competition,
        description: "A prestigious national competition for high school seniors to showcase their scientific research and compete for scholarships.",
        imageName: "atom"
    ),
    Opportunity(
        id: UUID(),
        title: "MIT THINK Scholars Program",
        category: .competition,
        description: "An annual competition for students with original research projects in science, technology, or engineering. Winners receive funding and mentorship.",
        imageName: "lightbulb.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "National Speech & Debate Tournament",
        category: .competition,
        description: "The largest academic competition in the country, where students compete in speech and debate to demonstrate public speaking and argumentation skills.",
        imageName: "mic.fill"
    ),

    // National Research Programs
    Opportunity(
        id: UUID(),
        title: "NIH High School Summer Internship Program",
        category: .research,
        description: "Conduct research at the National Institutes of Health and gain hands-on experience in biomedical research alongside leading scientists.",
        imageName: "stethoscope"
    ),
    Opportunity(
        id: UUID(),
        title: "USDA AgDiscovery Program",
        category: .research,
        description: "A summer program where students learn about careers in agriculture and animal science through hands-on activities and field trips.",
        imageName: "tortoise.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Girls Who Code Summer Immersion Program",
        category: .research,
        description: "A summer program that teaches high school girls coding skills and introduces them to careers in technology.",
        imageName: "desktopcomputer"
    ),
    
    // Additional Opportunities
    Opportunity(
        id: UUID(),
        title: "Lake County Public Library Assistant",
        category: .volunteer,
        description: "Assist with organizing materials, helping with community programs, and supporting literacy events at Lake County libraries.",
        imageName: "book.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Johns Hopkins Center for Talented Youth Summer Programs",
        category: .research,
        description: "Participate in courses covering topics like engineering, biomedical science, and computer science. Open to students with exceptional academic records.",
        imageName: "microscope"
    ),
    Opportunity(
        id: UUID(),
        title: "Prudential Spirit of Community Awards",
        category: .volunteer,
        description: "A national program honoring students in grades 5-12 who have made meaningful contributions to their communities through volunteer service.",
        imageName: "hands.sparkles"
    )
]

// Sample Badges
let sampleBadges: [Badge] = [
    Badge(title: "First Volunteer Hour", description: "Completed your first hour of volunteering.", imageName: "star"),
    Badge(title: "Community Leader", description: "Led a community volunteering event.", imageName: "person.3.fill"),
    Badge(title: "Global Citizen", description: "Contributed to a global volunteering project.", imageName: "globe"),
    Badge(title: "Research Enthusiast", description: "Completed your first research project.", imageName: "microscope"),
    Badge(title: "Competition Winner", description: "Won a national-level competition.", imageName: "trophy.fill"),
    Badge(title: "Internship Achiever", description: "Completed a government internship.", imageName: "briefcase.fill")
]

// MARK: - ViewModel
class OpportunityViewModel: ObservableObject {
    @Published var opportunities: [Opportunity] = sampleOpportunities
    @Published var user: User = User()
    @Published var isDarkMode: Bool = false
    
    // Star/Unstar Opportunity
    func toggleStar(for opportunity: Opportunity) {
        if let index = opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            opportunities[index].isStarred.toggle()
            if opportunities[index].isStarred {
                user.starredOpportunities.append(opportunity.id)
                assignBadgeIfNeeded(badge: sampleBadges[0]) // Example badge assignment
            } else {
                user.starredOpportunities.removeAll { $0 == opportunity.id }
                user.starredActivities.removeAll { $0.opportunity.id == opportunity.id }
            }
        }
    }
    
    // Track Time
    func addTime(for opportunity: Opportunity, hours: Double) {
        if let index = opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            opportunities[index].timeSpent += hours
            user.totalImpact.hoursVolunteered += hours
            // Additional impact tracking can be implemented here
        }
    }
    
    // Mark as Completed
    func markCompleted(for opportunity: Opportunity) {
        if let index = opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            opportunities[index].isCompleted = true
            assignBadgeIfNeeded(badge: sampleBadges[1]) // Example badge assignment
        }
    }
    
    // Assign Badge
    func assignBadgeIfNeeded(badge: Badge) {
        if !user.badges.contains(where: { $0.id == badge.id }) {
            user.badges.append(badge)
        }
    }
    
    // Create Event
    func createEvent(title: String, category: Category, description: String, imageName: String) {
        let newOpportunity = Opportunity(
            id: UUID(),
            title: title,
            category: category,
            description: description,
            imageName: imageName
        )
        opportunities.append(newOpportunity)
    }
    
    // Toggle Dark Mode
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
    
    // Add to Starred Activities
    func addStarredActivity(opportunity: Opportunity) {
        let starred = StarredActivity(opportunity: opportunity)
        if !user.starredActivities.contains(where: { $0.id == starred.id }) {
            user.starredActivities.append(starred)
        }
    }
    
    // Remove from Starred Activities
    func removeStarredActivity(opportunity: Opportunity) {
        user.starredActivities.removeAll { $0.opportunity.id == opportunity.id }
    }
}

// MARK: - Main App Structure with TabView
struct ContentView: View {
    @StateObject private var viewModel = OpportunityViewModel()
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .environmentObject(viewModel)
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .environmentObject(viewModel)
                    
                    VolunteerTrackerView()
                        .tabItem {
                            Label("Tracker", systemImage: "calendar")
                        }
                        .environmentObject(viewModel)
                    
                    BadgesView()
                        .tabItem {
                            Label("Badges", systemImage: "star.fill")
                        }
                        .environmentObject(viewModel)
                    
                    LeaderboardsView()
                        .tabItem {
                            Label("Leaderboards", systemImage: "chart.bar.fill")
                        }
                        .environmentObject(viewModel)
                    
                    CreateEventView()
                        .tabItem {
                            Label("Create", systemImage: "plus.circle.fill")
                        }
                        .environmentObject(viewModel)
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                        .environmentObject(viewModel)
                    
                    MoreView()
                        .tabItem {
                            Label("More", systemImage: "ellipsis.circle.fill")
                        }
                        .environmentObject(viewModel)
                }
                .accentColor(.primaryColor)
                .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
            }
        }
    }
}

// MARK: - OnboardingView
struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "hand.raised.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.primaryColor)
                
                Text("Welcome to ImpactLink!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                
                Text("Connect with local and national volunteering opportunities, track your impact, earn badges, and join a community dedicated to making a difference.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.primaryColor)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showOnboarding = false
                    }
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .accessibilityLabel(Text("Get Started Button"))
            }
            .padding()
        }
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
                    Text("Opportunities")
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
                                .accessibilityLabel(Text(category.rawValue))
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

// MARK: - VolunteerTrackerView
struct VolunteerTrackerView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                // Calendar and Graph
                ScrollView {
                    VStack(spacing: 20) {
                        // Calendar View
                        CalendarView(selectedDate: $selectedDate)
                            .frame(height: 300)
                            .padding()
                        
                        // Graph View
                        ImpactGraphView()
                            .frame(height: 300)
                            .padding()
                    }
                }
                .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            }
            .navigationBarTitle("Volunteer Tracker", displayMode: .inline)
        }
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentMonth: Date = Date()
    
    let days = Calendar.current.shortWeekdaySymbols
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primaryColor)
                        .padding()
                }
                
                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primaryColor)
                        .padding()
                }
            }
            
            // Weekday Headers
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondaryColor)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates Grid
            let dates = generateDates(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                ForEach(dates, id: \.self) { date in
                    if Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .day) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primaryColor)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                            .accessibilityLabel(Text("Selected Date \(Calendar.current.component(.day, from: date))"))
                    } else if Calendar.current.isDateInToday(date) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.secondaryColor.opacity(0.3))
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                            .accessibilityLabel(Text("Today, Date \(Calendar.current.component(.day, from: date))"))
                    } else if date == Date.distantPast {
                        Text("")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .foregroundColor(.primaryColor.opacity(0.6))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                selectedDate = date
                            }
                            .accessibilityLabel(Text("Date \(Calendar.current.component(.day, from: date))"))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func generateDates(for month: Date) -> [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: month),
              let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month)) else {
            return []
        }
        
        let firstWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        var dates: [Date] = []
        
        // Add empty dates for the first week
        for _ in 1..<firstWeekday {
            dates.append(Date.distantPast)
        }
        
        for day in range {
            if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        
        // Fill the remaining cells to complete the grid
        while dates.count % 7 != 0 {
            dates.append(Date.distantPast)
        }
        
        return dates
    }
}

// MARK: - ImpactGraphView
struct ImpactGraphView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weekly Impact")
                .font(.headline)
                .foregroundColor(.primaryColor)
                .padding(.horizontal)
            
            GeometryReader { geometry in
                let data = generateWeeklyData()
                let maxValue = data.map { $0.value }.max() ?? 1
                
                HStack(alignment: .bottom, spacing: 15) {
                    ForEach(data) { entry in
                        VStack {
                            Text("\(Int(entry.value))h")
                                .font(.caption)
                                .foregroundColor(.secondaryColor)
                            Rectangle()
                                .fill(Color.primaryColor)
                                .frame(width: 20, height: CGFloat(entry.value) / CGFloat(maxValue) * (geometry.size.height - 40))
                                .cornerRadius(5)
                                .animation(.easeOut(duration: 0.5), value: entry.value)
                            Text(entry.day)
                                .font(.caption)
                                .foregroundColor(.secondaryColor)
                        }
                        .accessibilityLabel(Text("\(entry.day): \(entry.value) hours"))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    struct GraphEntry: Identifiable {
        let id = UUID()
        let day: String
        let value: Double
    }
    
    func generateWeeklyData() -> [GraphEntry] {
        var entries: [GraphEntry] = []
        let calendar = Calendar.current
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let day = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                let hours = viewModel.opportunities.reduce(0.0) { $0 + ($1.timeSpent) }
                entries.append(GraphEntry(day: day, value: hours))
            }
        }
        return entries.reversed()
    }
}

// MARK: - BadgesView
struct BadgesView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.user.badges.isEmpty {
                    VStack {
                        Spacer()
                        Text("Earn badges by volunteering and participating!")
                            .font(.headline)
                            .foregroundColor(.secondaryColor)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.user.badges) { badge in
                                HStack {
                                    Image(systemName: badge.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.accentColor)
                                    VStack(alignment: .leading) {
                                        Text(badge.title)
                                            .font(.headline)
                                            .foregroundColor(.primaryColor)
                                        Text(badge.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondaryColor)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.cardBackgroundColor)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Badges", displayMode: .inline)
        }
    }
}

// MARK: - LeaderboardsView
struct LeaderboardsView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var topVolunteers: [User] {
        // Placeholder for top volunteers logic
        // In a real app, this would be fetched from a server
        return [viewModel.user] // Example with current user
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                if topVolunteers.isEmpty {
                    VStack {
                        Spacer()
                        Text("No data available.")
                            .font(.headline)
                            .foregroundColor(.secondaryColor)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(topVolunteers.indices, id: \.self) { index in
                                let volunteer = topVolunteers[index]
                                HStack {
                                    Text("\(index + 1). \(volunteer.username)")
                                        .font(.headline)
                                        .foregroundColor(.primaryColor)
                                    Spacer()
                                    Text("\(volunteer.totalImpact.hoursVolunteered, specifier: "%.1f") hrs")
                                        .font(.subheadline)
                                        .foregroundColor(.secondaryColor)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.cardBackgroundColor)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Leaderboards", displayMode: .inline)
        }
    }
}

// MARK: - CreateEventView
struct CreateEventView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var title: String = ""
    @State private var selectedCategory: Category = .volunteer
    @State private var description: String = ""
    @State private var imageName: String = "plus.circle.fill"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Event Details")) {
                        TextField("Title", text: $title)
                            .accessibilityLabel(Text("Event Title"))
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .accessibilityLabel(Text("Event Category"))
                        TextField("Description", text: $description)
                            .accessibilityLabel(Text("Event Description"))
                        TextField("Image Name (SF Symbol)", text: $imageName)
                            .accessibilityLabel(Text("Image Name"))
                    }
                    
                    Button(action: {
                        if title.isEmpty || description.isEmpty || imageName.isEmpty {
                            alertMessage = "All fields are required."
                            showAlert = true
                        } else {
                            viewModel.createEvent(title: title, category: selectedCategory, description: description, imageName: imageName)
                            alertMessage = "Event created successfully!"
                            showAlert = true
                            // Clear fields
                            title = ""
                            description = ""
                            imageName = "plus.circle.fill"
                        }
                    }) {
                        Text("Create Event")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .navigationBarTitle("Create Event", displayMode: .inline)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var skillInput: String = ""
    @State private var goalInput: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // User Info
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
                        
                        if viewModel.user.isLoggedIn {
                            Text("Hello, \(viewModel.user.username)!")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            
                            // Skills Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your Skills")
                                    .font(.headline)
                                    .foregroundColor(.primaryColor)
                                
                                ForEach(viewModel.user.skills, id: \.self) { skill in
                                    Text("• \(skill)")
                                        .foregroundColor(.secondaryColor)
                                }
                                
                                HStack {
                                    TextField("Add a skill", text: $skillInput)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondaryColor, lineWidth: 1))
                                        .accessibilityLabel(Text("Add Skill"))
                                    
                                    Button(action: {
                                        if !skillInput.isEmpty {
                                            viewModel.user.skills.append(skillInput)
                                            skillInput = ""
                                        } else {
                                            alertMessage = "Please enter a skill."
                                            showAlert = true
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.primaryColor)
                                    }
                                    .accessibilityLabel(Text("Add Skill Button"))
                                }
                            }
                            .padding(.horizontal)
                            
                            // Goals Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your Goals")
                                    .font(.headline)
                                    .foregroundColor(.primaryColor)
                                
                                ForEach(viewModel.user.goals, id: \.self) { goal in
                                    Text("• \(goal)")
                                        .foregroundColor(.secondaryColor)
                                }
                                
                                HStack {
                                    TextField("Set a goal", text: $goalInput)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondaryColor, lineWidth: 1))
                                        .accessibilityLabel(Text("Set Goal"))
                                    
                                    Button(action: {
                                        if !goalInput.isEmpty {
                                            viewModel.user.goals.append(goalInput)
                                            goalInput = ""
                                        } else {
                                            alertMessage = "Please enter a goal."
                                            showAlert = true
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.primaryColor)
                                    }
                                    .accessibilityLabel(Text("Add Goal Button"))
                                }
                            }
                            .padding(.horizontal)
                            
                            // Total Impact Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your Impact")
                                    .font(.headline)
                                    .foregroundColor(.primaryColor)
                                
                                Text("Hours Volunteered: \(viewModel.user.totalImpact.hoursVolunteered, specifier: "%.2f") hrs")
                                    .foregroundColor(.secondaryColor)
                                Text("People Helped: \(viewModel.user.totalImpact.peopleHelped)")
                                    .foregroundColor(.secondaryColor)
                                Text("Carbon Footprint Reduced: \(viewModel.user.totalImpact.carbonFootprintReduced, specifier: "%.2f") kg")
                                    .foregroundColor(.secondaryColor)
                            }
                            .padding(.horizontal)
                            
                            // Starred Activities Section
                            StarredActivitiesView()
                                .environmentObject(viewModel)
                            
                            // Logout Button
                            Button(action: {
                                withAnimation {
                                    viewModel.user.isLoggedIn = false
                                    viewModel.user.username = ""
                                    viewModel.user.skills.removeAll()
                                    viewModel.user.goals.removeAll()
                                    viewModel.user.starredOpportunities.removeAll()
                                    viewModel.user.starredActivities.removeAll()
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
                            .accessibilityLabel(Text("Logout Button"))
                        } else {
                            VStack(spacing: 15) {
                                TextField("Username", text: $viewModel.user.username)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.secondaryColor, lineWidth: 1))
                                    .accessibilityLabel(Text("Username"))
                                
                                Button(action: {
                                    if !viewModel.user.username.isEmpty {
                                        withAnimation {
                                            viewModel.user.isLoggedIn = true
                                        }
                                    } else {
                                        alertMessage = "Please enter a username."
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
                                .disabled(viewModel.user.username.isEmpty)
                                .accessibilityLabel(Text("Login Button"))
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
}

// MARK: - StarredActivitiesView
struct StarredActivitiesView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Starred Activities")
                .font(.headline)
                .foregroundColor(.primaryColor)
                .padding(.bottom, 5)
            
            if viewModel.user.starredActivities.isEmpty {
                Text("No starred activities. Star opportunities to save them here.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryColor)
            } else {
                ForEach(viewModel.user.starredActivities) { starred in
                    HStack {
                        Image(systemName: starred.opportunity.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.accentColor)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.cardBackgroundColor)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            )
                        VStack(alignment: .leading) {
                            Text(starred.opportunity.title)
                                .font(.headline)
                                .foregroundColor(.primaryColor)
                            Text(starred.opportunity.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondaryColor)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                viewModel.removeStarredActivity(opportunity: starred.opportunity)
                                viewModel.toggleStar(for: starred.opportunity)
                            }
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel(Text("Remove Starred Activity"))
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - MoreView
struct MoreView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $viewModel.isDarkMode) {
                        Text("Dark Mode")
                            .foregroundColor(.primaryColor)
                    }
                    .accessibilityLabel(Text("Dark Mode Toggle"))
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Text("About ImpactLink")
                            .foregroundColor(.primaryColor)
                    }
                }
            }
            .navigationBarTitle("More", displayMode: .inline)
        }
    }
}

// MARK: - AboutView
struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "info.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.primaryColor)
            
            Text("ImpactLink")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
            
            Text("ImpactLink connects students with volunteering opportunities, internships, competitions, and research programs. Track your volunteer hours, earn badges, and visualize your impact on the community.")
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.primaryColor)
            
            Spacer()
        }
        .padding()
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
                .accessibilityLabel(Text(opportunity.title))
            
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
                    if viewModel.user.starredOpportunities.contains(opportunity.id) {
                        viewModel.addStarredActivity(opportunity: opportunity)
                    }
                }
            }) {
                Image(systemName: opportunity.isStarred ? "star.fill" : "star")
                    .foregroundColor(opportunity.isStarred ? .yellow : .gray)
                    .scaleEffect(opportunity.isStarred ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: opportunity.isStarred)
            }
            .accessibilityLabel(opportunity.isStarred ? "Unstar Opportunity" : "Star Opportunity")
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
    @State private var safetyCheckedIn: Bool = false
    
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
                    .accessibilityLabel(Text(opportunity.title))
                
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
                            .accessibilityLabel(Text("Hours Spent"))
                        
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
                        .accessibilityLabel(Text("Add Time Button"))
                    }
                }
                
                // Safety Check-In
                VStack(alignment: .leading, spacing: 10) {
                    Text("Safety & Wellness")
                        .font(.headline)
                        .foregroundColor(.primaryColor)
                    
                    Toggle(isOn: $safetyCheckedIn) {
                        Text("Check-In for Safety")
                            .foregroundColor(.primaryColor)
                    }
                    .onChange(of: safetyCheckedIn) { value in
                        if value {
                            // Handle safety check-in logic here
                        }
                    }
                    .accessibilityLabel(Text("Safety Check-In Toggle"))
                }
                .padding(.horizontal)
                
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
                .accessibilityLabel(Text(opportunity.isCompleted ? "Completed" : "Mark as Completed Button"))
                
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

struct VolunteerTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerTrackerView()
            .environmentObject(OpportunityViewModel())
    }
}

struct BadgesView_Previews: PreviewProvider {
    static var previews: some View {
        BadgesView()
            .environmentObject(OpportunityViewModel())
    }
}

struct LeaderboardsView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardsView()
            .environmentObject(OpportunityViewModel())
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
            .environmentObject(OpportunityViewModel())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
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

struct StarredActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        StarredActivitiesView()
            .environmentObject(OpportunityViewModel())
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
            .environmentObject(OpportunityViewModel())
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedDate: .constant(Date()))
    }
}

struct ImpactGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ImpactGraphView()
            .environmentObject(OpportunityViewModel())
    }
}
