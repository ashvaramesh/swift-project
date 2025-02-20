import SwiftUI


// MARK: - Extended Color Palette (Ensure Completeness)
extension Color {
    // Existing Colors
    static let primaryColor = Color(red: 0.25, green: 0.47, blue: 0.85) // Blue
    static let secondaryColor = Color(red: 0.95, green: 0.77, blue: 0.06) // Yellow
    static let accentColor = Color(red: 0.95, green: 0.3, blue: 0.3) // Coral
    static let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95) // Light Gray
    static let cardBackgroundColor = Color.white
    
    // Existing Tag Colors
    static let volunteerTag = Color(red: 0.25, green: 0.47, blue: 0.85) // Blue
    static let governmentTag = Color(red: 0.95, green: 0.77, blue: 0.06) // Yellow
    static let competitionTag = Color(red: 0.95, green: 0.3, blue: 0.3) // Coral
    static let scienceTag = Color(red: 0.4, green: 0.6, blue: 0.4) // Green (Replaces Research)
    static let internshipTag = Color(red: 0.8, green: 0.4, blue: 0.8) // Purple
    
    // New Tag Colors
    static let educationTag = Color(red: 0.0, green: 0.6, blue: 0.8) // Teal
    static let environmentalTag = Color(red: 0.3, green: 0.7, blue: 0.3) // Light Green
    static let healthcareTag = Color(red: 0.9, green: 0.5, blue: 0.2) // Orange
    static let communityServiceTag = Color(red: 0.6, green: 0.2, blue: 0.8) // Purple
    static let artsCultureTag = Color(red: 0.8, green: 0.5, blue: 0.2) // Brown
    static let technologyTag = Color(red: 0.2, green: 0.6, blue: 0.9) // Light Blue
    static let advocacyTag = Color(red: 0.9, green: 0.2, blue: 0.6) // Pink
    static let leadershipTag = Color(red: 0.5, green: 0.3, blue: 0.0) // Dark Brown
    static let mathTag = Color(red: 0.7, green: 0.0, blue: 0.7) // Magenta
    static let engineeringTag = Color(red: 0.0, green: 0.5, blue: 0.5) // Teal
}



struct Opportunity: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let categories: [Category] // Updated to multiple categories
    let description: String
    let imageName: String
    var isStarred: Bool = false
    var timeSpent: Double = 0.0 // Time in hours
    var isCompleted: Bool = false
}


// MARK: - Opportunity Extension for MainCategory
extension Opportunity {
    var mainCategory: MainCategory {
        for category in categories {
            switch category {
            case .volunteer, .communityService, .artsCulture:
                return .communityImpact
            case .government, .internship, .leadership, .advocacy:
                return .professionalDevelopment
            case .environmental:
                return .sustainability
            case .competition, .science, .math, .engineering, .education:
                return .academics
            default:
                return .communityImpact // Default mapping
            }
        }
        return .communityImpact // Fallback
    }
}


// MARK: - Category Enum (Update)
enum Category: String, CaseIterable, Codable, Identifiable {
    case volunteer = "Volunteer"
    case government = "Government"
    case competition = "Competition"
    case science = "Science" // Replaced 'Research' with 'Science'
    case internship = "Internship"
    case education = "Education"
    case environmental = "Environmental"
    case healthcare = "Healthcare"
    case communityService = "Community Service"
    case artsCulture = "Arts & Culture"
    case technology = "Technology"
    case advocacy = "Advocacy"
    case leadership = "Leadership"
    case math = "Math"
    case engineering = "Engineering"

    var id: String { self.rawValue }
}

// MARK: - MainCategory Enum
enum MainCategory: String, CaseIterable, Identifiable, Codable {
    case communityImpact = "Community Impact"
    case professionalDevelopment = "Professional Development"
    case sustainability = "Sustainability"
    case academics = "Academics"
    
    var id: String { self.rawValue }
}

// MARK: - Grade Enum
enum Grade: String, CaseIterable, Identifiable, Codable {
    case highSchoolFreshman = "High School Freshman"
    case highSchoolSophomore = "High School Sophomore"
    case highSchoolJunior = "High School Junior"
    case highSchoolSenior = "High School Senior"
    case collegeFreshman = "College Freshman"
    case collegeSophomore = "College Sophomore"
    case collegeJunior = "College Junior"
    case collegeSenior = "College Senior"
    
    var id: String { self.rawValue }
}

struct Badge: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let imageName: String
}


struct ActivityEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var hours: Double
    var journal: String
}



struct StarredActivity: Identifiable, Codable, Hashable {
    let id: UUID
    let opportunity: Opportunity
    var entries: [ActivityEntry] = []
}



// MARK: - User Class (Updated for Firebase Authentication)
class User: ObservableObject, Codable {
    // Published Properties
    @Published var isLoggedIn: Bool = false
    @Published var email: String = ""
    @Published var uid: String = "" // Firebase User ID
    @Published var grade: Grade? = nil
    @Published var starredOpportunities: [UUID] = []
    @Published var skills: [String] = []
    @Published var goals: [String] = []
    @Published var badges: [Badge] = []
    @Published var totalImpact: Impact = Impact()
    @Published var starredActivities: [StarredActivity] = []
    @Published var isOrganizationAccount: Bool = false
    @Published var organizationName: String = ""
    @Published var contactName: String = ""
    @Published var interests: [Category] = []
    @Published var selectedState: String = "Illinois"
    @Published var selectedCounty: String = "Adams"
    @Published var username: String = ""

    // Declare the handle property
    private var handle: AuthStateDidChangeListenerHandle?

    // MARK: - Data Persistence Methods
    func saveUserData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
    }

    func loadUserData() {
        if let savedUserData = UserDefaults.standard.data(forKey: "userData") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(User.self, from: savedUserData) {
                self.isLoggedIn = decoded.isLoggedIn
                self.email = decoded.email
                self.uid = decoded.uid
                self.grade = decoded.grade
                self.starredOpportunities = decoded.starredOpportunities
                self.skills = decoded.skills
                self.goals = decoded.goals
                self.badges = decoded.badges
                self.totalImpact = decoded.totalImpact
                self.starredActivities = decoded.starredActivities
                self.interests = decoded.interests
                self.selectedState = decoded.selectedState
                self.selectedCounty = decoded.selectedCounty
                self.isOrganizationAccount = decoded.isOrganizationAccount
                self.organizationName = decoded.organizationName
                self.contactName = decoded.contactName
                self.username = decoded.username
            }
        }
    }

    // MARK: - Initializer
    init() {
        loadUserData()

        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.email = user.email ?? ""
                    self.uid = user.uid
                    self.username = user.displayName ?? "User" // Set username
                    // Load additional user data from Firestore if needed
                    self.saveUserData()
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.email = ""
                    self.uid = ""
                    self.username = ""
                    // Reset other properties
                    self.saveUserData()
                }
            }
        }
    }

    // Clean up the listener when the object is deinitialized
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Codable Conformance
    enum CodingKeys: CodingKey {
        case isLoggedIn, email, uid, grade, starredOpportunities, skills, goals, badges, totalImpact, starredActivities, interests, selectedState, selectedCounty, isOrganizationAccount, organizationName, contactName, username
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
        email = try container.decode(String.self, forKey: .email)
        uid = try container.decode(String.self, forKey: .uid)
        grade = try container.decodeIfPresent(Grade.self, forKey: .grade)
        starredOpportunities = try container.decode([UUID].self, forKey: .starredOpportunities)
        skills = try container.decode([String].self, forKey: .skills)
        goals = try container.decode([String].self, forKey: .goals)
        badges = try container.decode([Badge].self, forKey: .badges)
        totalImpact = try container.decode(Impact.self, forKey: .totalImpact)
        starredActivities = try container.decode([StarredActivity].self, forKey: .starredActivities)
        interests = try container.decode([Category].self, forKey: .interests)
        selectedState = try container.decode(String.self, forKey: .selectedState)
        selectedCounty = try container.decode(String.self, forKey: .selectedCounty)
        isOrganizationAccount = try container.decode(Bool.self, forKey: .isOrganizationAccount)
        organizationName = try container.decode(String.self, forKey: .organizationName)
        contactName = try container.decode(String.self, forKey: .contactName)
        username = try container.decode(String.self, forKey: .username)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isLoggedIn, forKey: .isLoggedIn)
        try container.encode(email, forKey: .email)
        try container.encode(uid, forKey: .uid)
        try container.encode(grade, forKey: .grade)
        try container.encode(starredOpportunities, forKey: .starredOpportunities)
        try container.encode(skills, forKey: .skills)
        try container.encode(goals, forKey: .goals)
        try container.encode(badges, forKey: .badges)
        try container.encode(totalImpact, forKey: .totalImpact)
        try container.encode(starredActivities, forKey: .starredActivities)
        try container.encode(interests, forKey: .interests)
        try container.encode(selectedState, forKey: .selectedState)
        try container.encode(selectedCounty, forKey: .selectedCounty)
        try container.encode(isOrganizationAccount, forKey: .isOrganizationAccount)
        try container.encode(organizationName, forKey: .organizationName)
        try container.encode(contactName, forKey: .contactName)
        try container.encode(username, forKey: .username)
    }
}



struct Impact: Codable, Hashable {
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
        categories: [.volunteer],
        description: "Assist with restoration projects, trail maintenance, and conservation efforts in the Lake County Forest Preserves. Perfect for students passionate about environmental protection.",
        imageName: "leaf.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Youth Leadership Program - Lake County Government",
        categories: [.government, .internship],
        description: "A leadership program focused on local government. Engage with Lake County officials and work on projects that impact local communities.",
        imageName: "building.2.crop.circle"
    ),
    Opportunity(
        id: UUID(),
        title: "Lake County Food Pantry Assistant",
        categories: [.volunteer],
        description: "Help organize, pack, and distribute food to families in need at local Lake County food pantries.",
        imageName: "cart.fill"
    ),

    // Illinois State Opportunities
    Opportunity(
        id: UUID(),
        title: "Illinois General Assembly Page for a Day",
        categories: [.government, .internship],
        description: "Experience a day in the Illinois General Assembly. Assist lawmakers and staff, and observe legislative proceedings in Springfield.",
        imageName: "megaphone.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Illinois State Science Fair",
        categories: [.competition, .science],
        description: "Participate in this statewide science fair and present your research on a variety of STEM topics.",
        imageName: "flask.fill"
    ),
    
    // National Volunteer & Government Programs
    Opportunity(
        id: UUID(),
        title: "National Parks Service - Youth Conservation Corps",
        categories: [.volunteer],
        description: "A summer work program for students who want to help conserve America's national parks. Participants assist with trail maintenance and habitat preservation.",
        imageName: "leaf.arrow.triangle.circlepath"
    ),
    Opportunity(
        id: UUID(),
        title: "Congressional Award Program",
        categories: [.government],
        description: "Earn a Congressional Award by setting and achieving personal goals in volunteer service, personal development, physical fitness, and expedition/exploration.",
        imageName: "star"
    ),

    // National Competitions
    Opportunity(
        id: UUID(),
        title: "Regeneron Science Talent Search",
        categories: [.competition, .science],
        description: "A prestigious national competition for high school seniors to showcase their scientific research and compete for scholarships.",
        imageName: "atom"
    ),
    Opportunity(
        id: UUID(),
        title: "MIT THINK Scholars Program",
        categories: [.competition, .science],
        description: "An annual competition for students with original research projects in science, technology, or engineering. Winners receive funding and mentorship.",
        imageName: "lightbulb.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "National Speech & Debate Tournament",
        categories: [.competition],
        description: "The largest academic competition in the country, where students compete in speech and debate to demonstrate public speaking and argumentation skills.",
        imageName: "mic.fill"
    ),

    // National Research Programs
    Opportunity(
        id: UUID(),
        title: "NIH High School Summer Internship Program",
        categories: [.science, .internship],
        description: "Conduct research at the National Institutes of Health and gain hands-on experience in biomedical research alongside leading scientists.",
        imageName: "stethoscope"
    ),
    Opportunity(
        id: UUID(),
        title: "USDA AgDiscovery Program",
        categories: [.science, .internship],
        description: "A summer program where students learn about careers in agriculture and animal science through hands-on activities and field trips.",
        imageName: "tortoise.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Girls Who Code Summer Immersion Program",
        categories: [.science, .internship],
        description: "A summer program that teaches high school girls coding skills and introduces them to careers in technology.",
        imageName: "desktopcomputer"
    ),
    
    // Additional Opportunities
    Opportunity(
        id: UUID(),
        title: "Lake County Public Library Assistant",
        categories: [.volunteer],
        description: "Assist with organizing materials, helping with community programs, and supporting literacy events at Lake County libraries.",
        imageName: "book.fill"
    ),
    Opportunity(
        id: UUID(),
        title: "Johns Hopkins Center for Talented Youth Summer Programs",
        categories: [.science, .internship],
        description: "Participate in courses covering topics like engineering, biomedical science, and computer science. Open to students with exceptional academic records.",
        imageName: "microscope"
    ),
    Opportunity(
        id: UUID(),
        title: "Prudential Spirit of Community Awards",
        categories: [.volunteer],
        description: "A national program honoring students in grades 5-12 who have made meaningful contributions to their communities through volunteer service.",
        imageName: "hands.sparkles"
    )
]

// Sample Badges
let sampleBadges: [Badge] = [
    Badge(id: UUID(), title: "First Volunteer Hour", description: "Completed your first hour of volunteering.", imageName: "star"),
    Badge(id: UUID(), title: "Community Leader", description: "Led a community volunteering event.", imageName: "person.3.fill"),
    Badge(id: UUID(), title: "Global Citizen", description: "Contributed to a global volunteering project.", imageName: "globe"),
    Badge(id: UUID(), title: "Research Enthusiast", description: "Completed your first research project.", imageName: "microscope"),
    Badge(id: UUID(), title: "Competition Winner", description: "Won a national-level competition.", imageName: "trophy.fill"),
    Badge(id: UUID(), title: "Internship Achiever", description: "Completed a government internship.", imageName: "briefcase.fill")
]



/// MARK: - Main App Structure with TabView
struct ContentView: View {
    @StateObject private var viewModel = OpportunityViewModel()
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .environmentObject(viewModel)
                    .transition(.opacity)
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .environmentObject(viewModel)
                    
                    VolunteerTrackerView()
                        .tabItem {
                            Label("Tracker", systemImage: "chart.bar")
                        }
                        .environmentObject(viewModel)
                    
                    LeaderboardsView() // Now includes Badges functionalities
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
                    
                    CommunityView() // New Community section
                        .tabItem {
                            Label("Community", systemImage: "person.3.fill")
                        }
                        .environmentObject(viewModel)
                }

            }
        }
        .animation(.easeInOut, value: showOnboarding)
    }
}


// MARK: - OnboardingView (Updated to Pass Binding to All Pages)
struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var currentPage: Int = 0

    var body: some View {
        ZStack {
            MovingGradientBackground() // Background applied once

            VStack {
                // The TabView for the onboarding pages
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)

                    OnboardingPage2(showOnboarding: $showOnboarding) // Pass binding
                        .tag(1)

                    OnboardingPage3(showOnboarding: $showOnboarding)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure TabView uses full screen space

                Spacer() // Spacer to push content up
                
                // Custom page control (dots)
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(currentPage == index ? .white : .gray.opacity(0.5))
                    }
                }
                .padding(.bottom, 40) // Moved the dots even lower

                Spacer() // Adds flexible space at the bottom for balance
            }
            .edgesIgnoringSafeArea(.all) // Ensure full use of the entire screen
        }
    }
}



// MARK: - HomeView (Add Search Bar and Filters)
struct HomeView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @Namespace private var animation
    @State private var searchText: String = ""
    @State private var isHighSchoolSelected: Bool = false
    @State private var isCollegeSelected: Bool = false
    
    // Computed property to filter opportunities based on selected categories, search text, and filters
    var filteredOpportunities: [Opportunity] {
        viewModel.opportunities.filter { opportunity in
            let matchesCategory = viewModel.selectedCategories.isEmpty || !viewModel.selectedCategories.isDisjoint(with: opportunity.categories)
            let matchesEducation = (!isHighSchoolSelected || (viewModel.user.grade?.rawValue.contains("High School") ?? false)) &&
                                   (!isCollegeSelected || (viewModel.user.grade?.rawValue.contains("College") ?? false))
            let matchesFilters = (!isHighSchoolSelected && !isCollegeSelected) || matchesEducation
            let matchesSearch = searchText.isEmpty || opportunity.title.lowercased().contains(searchText.lowercased())
            return matchesCategory && matchesFilters && matchesSearch
        }
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
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Category.allCases) { category in
                                Button(action: {
                                    if viewModel.selectedCategories.contains(category) {
                                        viewModel.selectedCategories.remove(category)
                                    } else {
                                        viewModel.selectedCategories.insert(category)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.square")
                                            .opacity(viewModel.selectedCategories.contains(category) ? 1 : 0)
                                        Text(category.rawValue)
                                            .font(.subheadline)
                                            .foregroundColor(viewModel.selectedCategories.contains(category) ? .white : .primaryColor)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(viewModel.selectedCategories.contains(category) ? colorForCategory(category) : Color.cardBackgroundColor)
                                            .shadow(color: viewModel.selectedCategories.contains(category) ? colorForCategory(category).opacity(0.4) : Color.clear, radius: 5, x: 0, y: 5)
                                    )
                                }
                                .accessibilityLabel(Text("\(category.rawValue) Category Toggle"))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                    
                    // New High School and College Filters
                    HStack {
                        Toggle(isOn: $isHighSchoolSelected) {
                            Text("High School")
                                .foregroundColor(.primaryColor)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .secondaryColor))
                        .accessibilityLabel(Text("High School Filter Toggle"))
                        
                        Toggle(isOn: $isCollegeSelected) {
                            Text("College")
                                .foregroundColor(.primaryColor)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .secondaryColor))
                        .accessibilityLabel(Text("College Filter Toggle"))
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    // Search Bar
                    TextField("Search by name", text: $searchText)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackgroundColor))
                        .padding(.horizontal)
                        .accessibilityLabel(Text("Search Bar"))
                    
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
            .onAppear {
                // Apply interests selected during onboarding
                viewModel.selectedCategories = Set(viewModel.user.interests)
                
                // Apply education level filters from onboarding
                if let grade = viewModel.user.grade {
                    if grade.rawValue.contains("High School") {
                        isHighSchoolSelected = true
                    }
                    if grade.rawValue.contains("College") {
                        isCollegeSelected = true
                    }
                }
            }

        }
    }
    
    // Helper function to get color for a category
    func colorForCategory(_ category: Category) -> Color {
        switch category {
        case .volunteer:
            return .volunteerTag
        case .government:
            return .governmentTag
        case .competition:
            return .competitionTag
        case .science:
            return .scienceTag
        case .internship:
            return .internshipTag
        case .education:
            return .educationTag
        case .environmental:
            return .environmentalTag
        case .healthcare:
            return .healthcareTag
        case .communityService:
            return .communityServiceTag
        case .artsCulture:
            return .artsCultureTag
        case .technology:
            return .technologyTag
        case .advocacy:
            return .advocacyTag
        case .leadership:
            return .leadershipTag
        case .math:
            return .mathTag
        case .engineering:
            return .engineeringTag
        }
    }
}


/// MARK: - Revamped VolunteerTrackerView with Native Charts
struct VolunteerTrackerView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var showingAddHours = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Charts Section
                    HStack(alignment: .top, spacing: 20) {
                        // Bar Chart for Weekly Hours
                        WeeklyHoursBarChart(data: viewModel.weeklyHours())
                            .frame(height: 300)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.cardBackgroundColor)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            )
                            .accessibilityLabel(Text("Bar Chart showing weekly hours volunteered"))
                        
                        // Pie Chart for Category Hours
                        CategoryHoursPieChart(data: viewModel.categoryHours())
                            .frame(height: 300)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.cardBackgroundColor)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            )
                            .accessibilityLabel(Text("Pie Chart showing hours by category"))
                    }
                    .padding(.horizontal)
                    
                    // Add Hours Button
                    Button(action: {
                        showingAddHours = true
                    }) {
                        Text("Add Hours")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.primaryColor.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showingAddHours) {
                        AddHoursView()
                            .environmentObject(viewModel)
                    }
                    
                    Divider()
                    
                    // Starred Activities Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Starred Activities")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .padding(.horizontal)
                        
                        if viewModel.user.starredActivities.isEmpty {
                            Text("No starred activities yet. Star opportunities to save them here.")
                                .font(.subheadline)
                                .foregroundColor(.secondaryColor)
                                .padding(.horizontal)
                        } else {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.user.starredActivities) { starred in
                                    NavigationLink(destination: StarredActivityDetailView(starredActivity: starred)) {
                                        StarredActivityCardView(starredActivity: starred)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
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
//MARK: Leaderboards View
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Leaderboards Section
                        Text("Top Volunteers")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .padding(.horizontal)
                        
                        if topVolunteers.isEmpty {
                            Text("No data available.")
                                .font(.headline)
                                .foregroundColor(.secondaryColor)
                                .padding(.horizontal)
                        } else {
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
                            .padding(.horizontal)
                        }
                        
                        // Badges Section
                        Text("Badges Earned")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .padding(.horizontal)
                        
                        if viewModel.user.badges.isEmpty {
                            Text("No badges earned yet. Start volunteering to earn badges!")
                                .font(.headline)
                                .foregroundColor(.secondaryColor)
                                .padding(.horizontal)
                        } else {
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
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
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
    @State private var selectedCategories: Set<Category> = []
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
                        
                        Text("Select Categories")
                            .font(.headline)
                            .foregroundColor(.primaryColor)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Category.allCases) { category in
                                    Button(action: {
                                        if selectedCategories.contains(category) {
                                            selectedCategories.remove(category)
                                        } else {
                                            selectedCategories.insert(category)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: selectedCategories.contains(category) ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedCategories.contains(category) ? colorForCategory(category) : .gray)
                                            Text(category.rawValue)
                                                .foregroundColor(selectedCategories.contains(category) ? .white : .primaryColor)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedCategories.contains(category) ? colorForCategory(category) : Color.cardBackgroundColor)
                                                .shadow(color: selectedCategories.contains(category) ? colorForCategory(category).opacity(0.4) : Color.clear, radius: 5, x: 0, y: 5)
                                        )
                                    }
                                    .accessibilityLabel(Text("\(category.rawValue) Category Toggle"))
                                }
                            }
                        }
                        
                        TextField("Description", text: $description)
                            .accessibilityLabel(Text("Event Description"))
                        TextField("Image Name (SF Symbol)", text: $imageName)
                            .accessibilityLabel(Text("Image Name"))
                    }
                    
                    Button(action: {
                        if title.isEmpty || description.isEmpty || imageName.isEmpty || selectedCategories.isEmpty {
                            alertMessage = "All fields and at least one category are required."
                            showAlert = true
                        } else {
                            viewModel.createEvent(title: title, category: Array(selectedCategories), description: description, imageName: imageName)
                            alertMessage = "Event created successfully!"
                            showAlert = true
                            // Clear fields
                            title = ""
                            description = ""
                            imageName = "plus.circle.fill"
                            selectedCategories.removeAll()
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
    
    // Helper function to get color for a category
    func colorForCategory(_ category: Category) -> Color {
        switch category {
        case .volunteer:
            return .volunteerTag
        case .government:
            return .governmentTag
        case .competition:
            return .competitionTag
        case .science:
            return .scienceTag
        case .internship:
            return .internshipTag
        case .education:
            return .educationTag
        case .environmental:
            return .environmentalTag
        case .healthcare:
            return .healthcareTag
        case .communityService:
            return .communityServiceTag
        case .artsCulture:
            return .artsCultureTag
        case .technology:
            return .technologyTag
        case .advocacy:
            return .advocacyTag
        case .leadership:
            return .leadershipTag
        case .math:
            return .mathTag
        case .engineering:
            return .engineeringTag
        }
    }
}

// MARK: - ProfileView (Updated for Firebase Authentication)
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
                        
                        if viewModel.user.isOrganizationAccount {
                            Text("Organization/School Account")
                                .font(.headline)
                                .foregroundColor(.primaryColor)
                                .padding(.top, 5)
                            
                            Text("Organization: \(viewModel.user.organizationName)")
                                .font(.subheadline)
                                .foregroundColor(.primaryColor)
                            
                            Text("Contact: \(viewModel.user.contactName)")
                                .font(.subheadline)
                                .foregroundColor(.primaryColor)
                        }

                        if viewModel.user.isLoggedIn {
                            Text("Hello, \(viewModel.user.email)!")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            
                            // Display Grade
                            if let grade = viewModel.user.grade {
                                Text("Grade: \(grade.rawValue)")
                                    .font(.headline)
                                    .foregroundColor(.primaryColor)
                                    .padding(.top, 5)
                            }
                            
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
                                            viewModel.saveUserData()
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
                                            viewModel.saveUserData()
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
                                    viewModel.logOut()
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
                            // If not logged in, prompt to complete onboarding
                            VStack(spacing: 15) {
                                Text("Please complete the onboarding to view your profile.")
                                    .font(.headline)
                                    .foregroundColor(.secondaryColor)
                                    .padding(.horizontal)
                                
                                // Optionally, navigate to OnboardingView or provide a link
                                // For simplicity, we'll just show a message
                            }
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



// MARK: - StarredActivitiesView (Updated)
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
                    NavigationLink(destination: StarredActivityDetailView(starredActivity: starred)) {
                        StarredActivityCardView(starredActivity: starred)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(Text("Navigate to \(starred.opportunity.title) details"))
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
                Section(header: Text("Profile")) {
                    if viewModel.user.isLoggedIn {
                        HStack {
                            Text("Username")
                            Spacer()
                            Text(viewModel.user.username)
                                .foregroundColor(.secondaryColor)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Interests")
                            Spacer()
                            VStack(alignment: .trailing) {
                                ForEach(viewModel.user.interests, id: \.self) { interest in
                                    Text(interest.rawValue)
                                        .font(.caption)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(Color.secondaryColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    } else {
                        Text("Please complete the onboarding to view your profile.")
                            .foregroundColor(.secondaryColor)
                    }
                }
                
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

// MARK: - Onboarding Pages
// MARK: - OnboardingPage1
struct OnboardingPage1: View {
    var body: some View {
        ZStack {
            MovingGradientBackground() // Use the gradient background
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "hand.raised.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .transition(.scale)
                
                Text("Welcome to ImpactLink!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Connect with volunteering opportunities, track your impact, earn badges, and join a community dedicated to making a difference.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}


// MARK: - OnboardingPage2 (Updated with Binding)
struct OnboardingPage2: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @Binding var showOnboarding: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedGrade: Grade? = nil
    @State private var selectedState: String = "Illinois" // Default State
    @State private var selectedCounty: String = "Adams" // Default County
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isOrganizationSheetPresented: Bool = false
    @State private var organizationName: String = ""
    @State private var contactName: String = ""
    @State private var isOrganizationAccount: Bool = false
    @State private var isSignUpMode: Bool = true
    @State private var errorMessage: String = ""
    @State private var usernameInput: String = ""


    // List of States (for now, only Illinois is populated with counties)
    let states = ["Illinois", "Other State"] // Add more states as needed

    // Illinois Counties
    let illinoisCounties = [
        "Adams", "Alexander", "Bond", "Boone", "Brown", "Bureau", "Calhoun",
        "Carroll", "Cass", "Champaign", "Christian", "Clark", "Clay", "Clinton",
        "Coles", "Cook", "Crawford", "Cumberland", "Dekalb", "Dewitt", "Douglas",
        "DuPage", "Edgar", "Edwards", "Effingham", "Fayette", "Ford",
        "Franklin", "Fulton", "Gallatin", "Greene", "Grundy", "Hamilton",
        "Hancock", "Hardin", "Henderson", "Henry", "Iroquois", "Jackson",
        "Jasper", "Jefferson", "Jersey", "Jo Daviess", "Johnson", "Kane",
        "Kankakee", "Kendall", "Knox", "LaSalle", "Lake", "Lawrence", "Lee",
        "Livingston", "Logan", "Macon", "Macoupin", "Madison", "Marion",
        "Marshall", "Mason", "Massac", "McDonough", "McHenry", "McLean",
        "Menard", "Mercer", "Monroe", "Montgomery", "Morgan", "Moultrie",
        "Ogle", "Peoria", "Perry", "Piatt", "Pike", "Pope", "Pulaski",
        "Putnam", "Randolph", "Richland", "Rock Island", "Saline", "Sangamon",
        "Schuyler", "Scott", "Shelby", "St. Clair", "Stark", "Stephenson",
        "Tazewell", "Union", "Vermilion", "Wabash", "Warren", "Washington",
        "Wayne", "White", "Whiteside", "Will", "Williamson", "Winnebago",
        "Woodford"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Log in or Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)

            // Email Field
            TextField("Enter your email", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                .foregroundColor(.white)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .accessibilityLabel(Text("Email Input"))

            // Password Field
            SecureField("Enter your password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                .foregroundColor(.white)
                .padding(.horizontal)
                .accessibilityLabel(Text("Password Input"))
            
            // Add a TextField for username
            TextField("Enter your username", text: $usernameInput)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                .foregroundColor(.white)
                .padding(.horizontal)
                .accessibilityLabel(Text("Username Input"))
            
            // Organization or School
            HStack {
                Text("Organization or School?")
                    .foregroundColor(.white.opacity(0.8))
                Button(action: {
                    isOrganizationSheetPresented = true
                }) {
                    Text("Click here")
                        .underline()
                        .foregroundColor(.secondaryColor)
                }
                .sheet(isPresented: $isOrganizationSheetPresented) {
                    OrganizationSheet(
                        isPresented: $isOrganizationSheetPresented,
                        organizationName: $organizationName,
                        contactName: $contactName,
                        isOrganizationAccount: $isOrganizationAccount
                    )
                }
                .accessibilityLabel(Text("Organization Click Here Button"))
                
                if isOrganizationAccount {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal)

            // Grade Selection
            Text("Select Your Grade")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)

            // Use LazyVGrid for Grade Selection
            let columns = [GridItem(.adaptive(minimum: 150), spacing: 15)]
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Grade.allCases) { gradeOption in
                    Button(action: {
                        selectedGrade = selectedGrade == gradeOption ? nil : gradeOption
                    }) {
                        Text(gradeOption.rawValue)
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedGrade == gradeOption ? Color.secondaryColor : Color.white.opacity(0.2))
                            )
                            .foregroundColor(selectedGrade == gradeOption ? .white : .white.opacity(0.8))
                    }
                    .accessibilityLabel(Text("\(gradeOption.rawValue) Grade Toggle"))
                }
            }
            .padding(.horizontal)

            // Select Your Location
            HStack(spacing: 10) {
                Image(systemName: "location.fill")
                    .foregroundColor(.white)
                Text("Select Your Location")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.top, 20)

            // State Dropdown
            Picker("Select State", selection: $selectedState) {
                ForEach(states, id: \.self) { state in
                    Text(state).tag(state)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
            .foregroundColor(.white)
            .padding(.horizontal)
            .accessibilityLabel(Text("Select State Picker"))

            // County Dropdown (only show for Illinois)
            if selectedState == "Illinois" {
                Picker("Select County", selection: $selectedCounty) {
                    ForEach(illinoisCounties, id: \.self) { county in
                        Text(county).tag(county)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                .foregroundColor(.white)
                .padding(.horizontal)
                .accessibilityLabel(Text("Select County Picker"))
            } else {
                // Placeholder or alternative counties for other states can be added here
                Picker("Select County", selection: $selectedCounty) {
                    Text("N/A").tag("N/A")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                .foregroundColor(.white)
                .padding(.horizontal)
                .disabled(true)
                .accessibilityLabel(Text("Select County Picker Disabled"))
            }

            Spacer()

            // Save Profile Button
            Button(action: {
                if email.isEmpty || password.isEmpty || selectedGrade == nil {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                } else {
                    if isSignUpMode {
                        viewModel.signUp(email: email, password: password) { result in
                            switch result {
                            case .success():
                                // Update display name
                                if let currentUser = Auth.auth().currentUser {
                                    let changeRequest = currentUser.createProfileChangeRequest()
                                    changeRequest.displayName = usernameInput
                                    changeRequest.commitChanges { error in
                                        if let error = error {
                                            alertMessage = error.localizedDescription
                                            showAlert = true
                                        } else {
                                            // Save additional user data
                                            viewModel.user.grade = selectedGrade
                                            viewModel.user.selectedState = selectedState
                                            viewModel.user.selectedCounty = selectedCounty
                                            viewModel.user.isOrganizationAccount = isOrganizationAccount
                                            viewModel.user.organizationName = organizationName
                                            viewModel.user.contactName = contactName
                                            viewModel.user.saveUserData()
                                            alertMessage = "Sign Up Successful!"
                                            showAlert = true
                                            showOnboarding = false
                                        }
                                    }
                                }
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }

                    } else {
                        viewModel.logIn(email: email, password: password) { result in
                            switch result {
                            case .success():
                                // Load additional user data
                                viewModel.user.grade = selectedGrade
                                viewModel.user.selectedState = selectedState
                                viewModel.user.selectedCounty = selectedCounty
                                viewModel.user.isOrganizationAccount = isOrganizationAccount
                                viewModel.user.organizationName = organizationName
                                viewModel.user.contactName = contactName
                                viewModel.user.saveUserData()
                                alertMessage = "Login Successful!"
                                showAlert = true
                                showOnboarding = false
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                }
            }) {
                Text(isSignUpMode ? "Sign Up" : "Log In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSignUpMode ? Color.secondaryColor : Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .padding(.bottom, 50)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Profile"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            // Toggle between Sign Up and Log In
            HStack {
                Text(isSignUpMode ? "Already have an account?" : "Don't have an account?")
                    .foregroundColor(.white.opacity(0.8))
                Button(action: {
                    isSignUpMode.toggle()
                }) {
                    Text(isSignUpMode ? "Log In" : "Sign Up")
                        .underline()
                        .foregroundColor(.secondaryColor)
                }
                .accessibilityLabel(Text("Switch Authentication Mode Button"))
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Modified OnboardingPage3
struct OnboardingPage3: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @Binding var showOnboarding: Bool
    @State private var selectedFilters = Set<Category>() // Initialize as empty set

    let columns = [GridItem(.adaptive(minimum: 120), spacing: 15)]

    var recommendedOpportunities: [Opportunity] {
        viewModel.opportunities.filter { opportunity in
            !selectedFilters.isDisjoint(with: opportunity.categories)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Choose Your Interests")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)

            // Filter Selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Category.allCases) { category in
                        Button(action: {
                            if selectedFilters.contains(category) {
                                selectedFilters.remove(category)
                            } else {
                                selectedFilters.insert(category)
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(selectedFilters.contains(category) ? .white : .white.opacity(0.5))
                                Text(category.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedFilters.contains(category) ? Color.accentColor : Color.white.opacity(0.2))
                            )
                        }
                        .accessibilityLabel(Text("\(category.rawValue) Filter Toggle"))
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            if !recommendedOpportunities.isEmpty {
                Text("Recommended Opportunities")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                // Smooth Carousel
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(recommendedOpportunities) { opportunity in
                                OpportunityCardView(opportunity: opportunity)
                                    .frame(width: geometry.size.width * 0.8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white.opacity(0.2))
                                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    )
                                    .accessibilityLabel(Text(opportunity.title))
                            }
                        }
                        .padding(.horizontal)
                        .offset(x: animateCarousel ? -geometry.size.width * 0.8 : 0)
                        .animation(Animation.linear(duration: Double(recommendedOpportunities.count) * 2).repeatForever(autoreverses: false), value: animateCarousel)
                        .onAppear {
                            animateCarousel.toggle()
                        }
                    }
                }
                .frame(height: 250)
            }

            Spacer()

            // Get Started Button
            Button(action: {
                // Save selected filters as interests
                viewModel.user.interests = Array(selectedFilters)
                viewModel.user.saveUserData()
                showOnboarding = false
            }) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
            .accessibilityLabel(Text("Get Started Button"))
        }
        .background(
            MovingGradientBackground()
        )
        .onAppear {
            // Initialize selectedFilters after the view has been initialized
            selectedFilters = Set(viewModel.user.interests)
        }
    }

    // MARK: - Carousel Animation State
    @State private var animateCarousel: Bool = false
}



// MARK: - Modified WrapView for Single and Multiple Selections
struct WrapView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable & Equatable {
    var items: Data
    @Binding var selectedItems: [Data.Element]
    var content: (Data.Element, Bool) -> Content
    
    init(items: Data, selectedItems: Binding<[Data.Element]>, @ViewBuilder content: @escaping (Data.Element, Bool) -> Content) {
        self.items = items
        self._selectedItems = selectedItems
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items) { item in
                content(item, selectedItems.contains(item))
                    .padding([.horizontal, .vertical], 5)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if item.id == items.last?.id {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        return result
                    })
            }
        }
    }
}

// MARK: - Moving Gradient Background
struct MovingGradientBackground: View {
    @State private var animateGradient = false
    
    private let startColor: Color = .blue
    private let endColor: Color = .green
    
    var body: some View {
        LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all) // Make sure it covers the entire screen
            .hueRotation(.degrees(animateGradient ? 45 : 0)) // Apply hue rotation
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
    }
}



// MARK: - OpportunityCardView
struct OpportunityCardView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    let opportunity: Opportunity
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
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
                    //Text(opportunity.categories.map { $0.rawValue }.joined(separator: ", "))
                     //   .font(.subheadline)
                      //  .foregroundColor(.secondaryColor)
                    
                    // Tags
                    HStack {
                        ForEach(opportunity.categories, id: \.self) { category in
                            Text(category.rawValue)
                                .font(.caption)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(colorForCategory(category))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityLabel(Text("\(category.rawValue) Tag"))
                        }
                    }
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
                .accessibilityLabel(opportunity.isStarred ? "Unstar Opportunity" : "Star Opportunity")

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
    
    // Helper function to get color for a category
    func colorForCategory(_ category: Category) -> Color {
        switch category {
        case .volunteer:
            return .volunteerTag
        case .government:
            return .governmentTag
        case .competition:
            return .competitionTag
        case .science:
            return .scienceTag
        case .internship:
            return .internshipTag
        case .education:
            return .educationTag
        case .environmental:
            return .environmentalTag
        case .healthcare:
            return .healthcareTag
        case .communityService:
            return .communityServiceTag
        case .artsCulture:
            return .artsCultureTag
        case .technology:
            return .technologyTag
        case .advocacy:
            return .advocacyTag
        case .leadership:
            return .leadershipTag
        case .math:
            return .mathTag
        case .engineering:
            return .engineeringTag
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
                
                // Categories
                Text(opportunity.categories.map { $0.rawValue }.joined(separator: ", "))
                    .font(.title3)
                    .foregroundColor(.secondaryColor)
                
                // Description
                Text(opportunity.description)
                    .font(.body)
                    .foregroundColor(.primaryColor)
                
                // Tags
                HStack {
                    ForEach(opportunity.categories, id: \.self) { category in
                        Text(category.rawValue)
                            .font(.caption)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(colorForCategory(category))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .accessibilityLabel(Text("\(category.rawValue) Tag"))
                    }
                }
                
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
                    .onChange(of: safetyCheckedIn) { oldValue, newValue in
                        if newValue {
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
    
    // Helper function to get color for a category
    func colorForCategory(_ category: Category) -> Color {
        switch category {
        case .volunteer:
            return .volunteerTag
        case .government:
            return .governmentTag
        case .competition:
            return .competitionTag
        case .science:
            return .scienceTag
        case .internship:
            return .internshipTag
        case .education:
            return .educationTag
        case .environmental:
            return .environmentalTag
        case .healthcare:
            return .healthcareTag
        case .communityService:
            return .communityServiceTag
        case .artsCulture:
            return .artsCultureTag
        case .technology:
            return .technologyTag
        case .advocacy:
            return .advocacyTag
        case .leadership:
            return .leadershipTag
        case .math:
            return .mathTag
        case .engineering:
            return .engineeringTag
        }
    }
}

// MARK: - WeeklyHoursBarChart View
import SwiftUI
import Charts

struct WeeklyHoursBarChart: View {
    var data: [String: Double]
    
    var body: some View {
        VStack {
            Text("Weekly Hours Volunteered")
                .font(.headline)
                .foregroundColor(.primaryColor)
                .padding(.bottom, 5)
            
            Chart {
                ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { day, hours in
                    BarMark(
                        x: .value("Day", day),
                        y: .value("Hours", hours)
                    )
                    .foregroundStyle(Color.primaryColor)
                    .accessibilityLabel(Text("\(day): \(hours, specifier: "%.1f") hours"))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: data.keys.sorted()) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(height: 200)
        }
    }
}

// MARK: - CategoryHoursPieChart View
import SwiftUI
import Charts

struct CategoryHoursPieChart: View {
    var data: [MainCategory: Double]
    
    var body: some View {
        VStack {
            Text("Hours by Category")
                .font(.headline)
                .foregroundColor(.primaryColor)
                .padding(.bottom, 5)
            
            Chart {
                ForEach(data.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { category in
                    if let hours = data[category], hours > 0 {
                        SectorMark(
                            angle: .value("Hours", hours),
                            innerRadius: 0.5,
                            outerRadius: 0.9
                        )
                        .foregroundStyle(colorForCategory(category))
                        .annotation(position: .overlay) {
                            Text("\(Int(hours))h")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel(Text("\(category.rawValue): \(hours, specifier: "%.1f") hours"))
                    }
                }
            }
            .chartLegend(.hidden)
            .frame(height: 200)
        }
    }
    
    // Helper function to get color for a main category
    func colorForCategory(_ category: MainCategory) -> Color {
        switch category {
        case .communityImpact:
            return .volunteerTag
        case .professionalDevelopment:
            return .governmentTag
        case .sustainability:
            return .environmentalTag
        case .academics:
            return .scienceTag
        }
    }
}


// MARK: - AddHoursView
import SwiftUI

struct AddHoursView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedOpportunity: StarredActivity? = nil
    @State private var hours: String = ""
    @State private var journal: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Activity")) {
                    Picker("Activity", selection: $selectedOpportunity) {
                        ForEach(viewModel.user.starredActivities) { starred in
                            Text(starred.opportunity.title).tag(Optional(starred))
                        }
                    }
                    .accessibilityLabel(Text("Select Activity Picker"))
                }
                
                Section(header: Text("Details")) {
                    TextField("Hours", text: $hours)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(Text("Hours Input"))
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .accessibilityLabel(Text("Select Date Picker"))
                    
                    TextField("Journal Entry", text: $journal)
                        .accessibilityLabel(Text("Journal Entry Input"))
                }
            }
            .navigationBarTitle("Add Hours", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveEntry()
            }
            .disabled(selectedOpportunity == nil || Double(hours) == nil || hours.isEmpty || journal.isEmpty))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func saveEntry() {
        guard let starred = selectedOpportunity,
              let hoursDouble = Double(hours),
              !journal.isEmpty else {
            alertMessage = "Please fill in all fields correctly."
            showAlert = true
            return
        }
        
        let newEntry = ActivityEntry(id: UUID(), date: selectedDate, hours: hoursDouble, journal: journal)
        viewModel.addJournalEntry(opportunity: starred.opportunity, entry: newEntry)
        presentationMode.wrappedValue.dismiss()
    }
}


// MARK: - StarredActivityCardView
import SwiftUI

struct StarredActivityCardView: View {
    let starredActivity: StarredActivity
    
    var body: some View {
        HStack {
            Image(systemName: starredActivity.opportunity.imageName)
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
                .accessibilityLabel(Text(starredActivity.opportunity.title))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(starredActivity.opportunity.title)
                    .font(.headline)
                    .foregroundColor(.primaryColor)
                Text(starredActivity.opportunity.categories.map { $0.rawValue }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondaryColor)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
        )
    }
}

// MARK: - StarredActivityDetailView
import SwiftUI

struct StarredActivityDetailView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var starredActivity: StarredActivity
    @State private var showingAddEntry = false
    @State private var showDeleteAlert = false
    @State private var entryToDelete: ActivityEntry? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Activity Info
                HStack {
                    Image(systemName: starredActivity.opportunity.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.cardBackgroundColor)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        )
                        .accessibilityLabel(Text(starredActivity.opportunity.title))
                    
                    VStack(alignment: .leading) {
                        Text(starredActivity.opportunity.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                        Text(starredActivity.opportunity.categories.map { $0.rawValue }.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondaryColor)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Journal Entries
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Journal Entries")
                            .font(.headline)
                            .foregroundColor(.primaryColor)
                        Spacer()
                        Button(action: {
                            showingAddEntry = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.primaryColor)
                        }
                        .accessibilityLabel(Text("Add Journal Entry Button"))
                    }
                    .padding(.horizontal)
                    
                    if starredActivity.entries.isEmpty {
                        Text("No journal entries yet.")
                            .font(.subheadline)
                            .foregroundColor(.secondaryColor)
                            .padding(.horizontal)
                    } else {
                        LazyVStack(spacing: 15) {
                            ForEach(starredActivity.entries.sorted(by: { $0.date > $1.date })) { entry in
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(entry.date, style: .date)
                                            .font(.headline)
                                            .foregroundColor(.primaryColor)
                                        Spacer()
                                        Text("\(entry.hours, specifier: "%.1f") hrs")
                                            .font(.subheadline)
                                            .foregroundColor(.secondaryColor)
                                    }
                                    Text(entry.journal)
                                        .font(.body)
                                        .foregroundColor(.primaryColor)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.cardBackgroundColor)
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                                )
                                .contextMenu {
                                    Button(action: {
                                        entryToDelete = entry
                                        showDeleteAlert = true
                                    }) {
                                        Text("Delete Entry")
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationBarTitle("Activity Details", displayMode: .inline)
        .sheet(isPresented: $showingAddEntry) {
            AddJournalEntryView(starredActivity: $starredActivity)
                .environmentObject(viewModel)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Delete Entry"),
                  message: Text("Are you sure you want to delete this entry?"),
                  primaryButton: .destructive(Text("Delete")) {
                   if let entry = entryToDelete {
                    viewModel.removeActivityEntry(opportunity: starredActivity.opportunity, entry: entry)
                    refreshStarredActivity()
                   }

                  },
                  secondaryButton: .cancel())
        }
    }
    
    func refreshStarredActivity() {
        if let index = viewModel.user.starredActivities.firstIndex(where: { $0.id == starredActivity.id }) {
            viewModel.user.starredActivities[index] = starredActivity
        }
    }
}

// MARK: - AddJournalEntryView
import SwiftUI

struct AddJournalEntryView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var starredActivity: StarredActivity
    
    @State private var selectedDate: Date = Date()
    @State private var hours: String = ""
    @State private var journal: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .accessibilityLabel(Text("Select Date Picker"))
                }
                
                Section(header: Text("Hours")) {
                    TextField("Enter hours", text: $hours)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(Text("Hours Input"))
                }
                
                Section(header: Text("Journal Entry")) {
                    TextEditor(text: $journal)
                        .frame(height: 150)
                        .accessibilityLabel(Text("Journal Entry TextEditor"))
                }
            }
            .navigationBarTitle("Add Entry", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveEntry()
            }
            .disabled(hours.isEmpty || journal.isEmpty || Double(hours) == nil))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func saveEntry() {
        guard let hoursDouble = Double(hours), !journal.isEmpty else {
            alertMessage = "Please fill in all fields correctly."
            showAlert = true
            return
        }
        
        let newEntry = ActivityEntry(id: UUID(), date: selectedDate, hours: hoursDouble, journal: journal)
        viewModel.addJournalEntry(opportunity: starredActivity.opportunity, entry: newEntry)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddJournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddJournalEntryView(starredActivity: .constant(StarredActivity(
            id: UUID(),
            opportunity: sampleOpportunities[0],
            entries: []
        )))
        .environmentObject(OpportunityViewModel())
    }
}

struct StarredActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StarredActivityDetailView(starredActivity: StarredActivity(
            id: UUID(),
            opportunity: sampleOpportunities[0],
            entries: []
        ))
        .environmentObject(OpportunityViewModel())
    }
}

struct StarredActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        StarredActivityCardView(starredActivity: StarredActivity(
            id: UUID(),
            opportunity: sampleOpportunities[0],
            entries: []
        ))
        .previewLayout(.sizeThatFits)
        .environmentObject(OpportunityViewModel())
    }
}

struct AddHoursView_Previews: PreviewProvider {
    static var previews: some View {
        AddHoursView()
            .environmentObject(OpportunityViewModel())
    }
}

struct CategoryHoursPieChart_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHoursPieChart(data: [
            .communityImpact: 15,
            .professionalDevelopment: 10,
            .sustainability: 5,
            .academics: 20
        ])
        .previewLayout(.sizeThatFits)
    }
}


struct WeeklyHoursBarChart_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyHoursBarChart(data: [
            "Mon": 5,
            "Tue": 3,
            "Wed": 4,
            "Thu": 2,
            "Fri": 6,
            "Sat": 0,
            "Sun": 1
        ])
        .previewLayout(.sizeThatFits)
    }
}


// MARK: - Previews
struct OpportunityDetailView_Previews: PreviewProvider {
static var previews: some View {
    OpportunityDetailView(opportunity: sampleOpportunities[0])
        .environmentObject(OpportunityViewModel())
}
}





// Mark: CHATBOT

import SwiftUI
import Combine

// MARK: - ChatMessage Model
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: String // "user" or "assistant"
    let content: String
}

// MARK: - OpenAI Response Models
struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let finish_reason: String?
}

struct Message: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

// MARK: - ChatViewModel
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // Replace with your actual OpenAI API key
    private let apiKey: String = "YOUR_OPENAI_API_KEY"
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        // Append user's message
        let userMessage = ChatMessage(role: "user", content: trimmedInput)
        messages.append(userMessage)
        userInput = ""
        
        // Prepare request
        guard let url = URL(string: apiURL) else {
            self.errorMessage = "Invalid API URL."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ChatGPT requires messages in a specific format
        let requestBody: [String: Any] = [
            "model": "gpt-4", // or "gpt-3.5-turbo"
            "messages": messages.map { ["role": $0.role, "content": $0.content] }
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            self.errorMessage = "Failed to encode request."
            return
        }
        
        isLoading = true
        
        // Perform network request
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                // Check for HTTP errors
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: OpenAIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let assistantMessage = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) {
                    let assistant = ChatMessage(role: "assistant", content: assistantMessage)
                    self.messages.append(assistant)
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - ChatView
struct ChatView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @StateObject private var chatVM = ChatViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(chatVM.messages) { message in
                                HStack {
                                    if message.role == "user" {
                                        Spacer()
                                        Text(message.content)
                                            .padding()
                                            .background(Color.primaryColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                                            .accessibilityLabel(Text("User message: \(message.content)"))
                                    } else {
                                        Text(message.content)
                                            .padding()
                                            .background(Color.secondaryColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                                            .accessibilityLabel(Text("Assistant message: \(message.content)"))
                                        Spacer()
                                    }
                                }
                            }
                            if chatVM.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .primaryColor))
                                        .accessibilityLabel(Text("Loading assistant response"))
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .onChange(of: chatVM.messages.count) { _ in
                            withAnimation {
                                proxy.scrollTo(chatVM.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Field
                HStack {
                    TextField("Type your message...", text: $chatVM.userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)
                        .accessibilityLabel(Text("Chat input field"))
                    
                    Button(action: {
                        chatVM.sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .rotationEffect(.degrees(45))
                            .foregroundColor(chatVM.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .primaryColor)
                    }
                    .disabled(chatVM.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel(Text("Send message button"))
                }
                .padding()
            }
            .navigationBarTitle("ChatGPT Assistant", displayMode: .inline)
            .alert(isPresented: Binding<Bool>(
                get: { !chatVM.errorMessage.isEmpty },
                set: { _ in chatVM.errorMessage = "" }
            )) {
                Alert(title: Text("Error"), message: Text(chatVM.errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Optionally, you can send a welcome message
                if chatVM.messages.isEmpty {
                    chatVM.messages.append(ChatMessage(role: "assistant", content: "Hello! I'm here to help you find the best opportunities. How can I assist you today?"))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // To ensure proper layout on iPad
    }
}

// MARK: - Updated ContentView with Chat Tab
struct ContentView: View {
    @StateObject private var viewModel = OpportunityViewModel()
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .environmentObject(viewModel)
                    .transition(.opacity)
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .environmentObject(viewModel)
                    
                    VolunteerTrackerView()
                        .tabItem {
                            Label("Tracker", systemImage: "chart.bar")
                        }
                        .environmentObject(viewModel)
                    
                    LeaderboardsView() // Now includes Badges functionalities
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
                    
                    CommunityView() // New Community section
                        .tabItem {
                            Label("Community", systemImage: "person.3.fill")
                        }
                        .environmentObject(viewModel)
                    
                    // New Chat Tab
                    ChatView()
                        .tabItem {
                            Label("Chat", systemImage: "message.fill")
                        }
                        .environmentObject(viewModel)
                }
            }
        }
        .animation(.easeInOut, value: showOnboarding)
    }
}

// MARK: - Preview Providers (Optional)
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(OpportunityViewModel())
    }
}

struct ChatViewModel_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(OpportunityViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - ImagePicker for Journal Entry
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}

// MARK: - Random Opportunity Section
struct RandomOpportunityView: View {
    @EnvironmentObject var viewModel: OpportunityViewModel
    @State private var randomOpportunity: Opportunity? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Feeling Spontaneous?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
                .accessibilityLabel(Text("Random Opportunity Section Title"))
            
            if let opportunity = randomOpportunity {
                // Display the opportunity card using our existing view
                OpportunityCardView(opportunity: opportunity)
                    .accessibilityLabel(Text("Random Opportunity: \(opportunity.title)"))
            } else {
                Text("No opportunities available at the moment.")
                    .foregroundColor(.secondaryColor)
                    .accessibilityLabel(Text("No opportunities message"))
            }
            
            Button(action: {
                selectRandomOpportunity()
            }) {
                Text("Discover Another")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .accessibilityLabel(Text("Discover Another Random Opportunity"))
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            selectRandomOpportunity()
        }
    }
    
    private func selectRandomOpportunity() {
        if !viewModel.opportunities.isEmpty {
            randomOpportunity = viewModel.opportunities.randomElement()
        }
    }
}

import SwiftUI

// MARK: - Dummy Data Models

struct Opportunity: Identifiable {
    let id = UUID()
    let title: String
    let category: String
}

struct Event: Identifiable {
    let id = UUID()
    let name: String
    let date: String
}

// MARK: - Dynamic Opportunity Feed

struct OpportunityFeedView: View {
    // Dummy opportunities for the feed
    let opportunities = [
        Opportunity(title: "Volunteer at Local Shelter", category: "Volunteer"),
        Opportunity(title: "Research Assistant Position", category: "Research"),
        Opportunity(title: "Government Internship", category: "Government")
    ]
    
    var body: some View {
        NavigationView {
            List(opportunities) { opportunity in
                HStack {
                    // Color-coded indicator based on category
                    Circle()
                        .fill(color(for: opportunity.category))
                        .frame(width: 10, height: 10)
                    Text(opportunity.title)
                        .font(.body)
                }
            }
            .navigationTitle("Opportunity Feed")
        }
    }
    
    func color(for category: String) -> Color {
        switch category {
        case "Volunteer":
            return .green
        case "Research":
            return .blue
        case "Government":
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Interactive Profile Customization

struct ProfileCustomizationView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var bannerText: String = "Welcome to my profile!"
    @State private var bio: String = "This is my bio. Tell us about yourself."
    
    var body: some View {
        VStack(spacing: 20) {
            // Banner
            Text(bannerText)
                .font(.headline)
                .padding()
                .background(Color.orange.opacity(0.3))
                .cornerRadius(8)
            
            // Profile image placeholder
            profileImage
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            // Editable bio field
            TextField("Enter your bio", text: $bio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Dummy progress tracker
            ProgressView("Engagement", value: 0.5, total: 1.0)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
    }
}

// MARK: - Improved UI for Event Listings

struct EventListingsView: View {
    // Dummy event data
    let events = [
        Event(name: "Community Meetup", date: "Feb 20"),
        Event(name: "Charity Run", date: "Mar 15"),
        Event(name: "Career Fair", date: "Apr 10")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(events) { event in
                        VStack(alignment: .leading) {
                            Text(event.name)
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text(event.date)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                        .padding(4)
                    }
                }
                .padding()
            }
            .navigationTitle("Events")
        }
    }
}

// MARK: - Community Hub (Beta)

struct CommunityHubView: View {
    // Dummy posts for the community hub
    let posts = [
        "Great opportunity at XYZ organization!",
        "Check out our new community event.",
        "Volunteer needed for upcoming festival."
    ]
    
    var body: some View {
        NavigationView {
            List(posts, id: \.self) { post in
                VStack(alignment: .leading, spacing: 8) {
                    Text(post)
                        .font(.body)
                    // Dummy buttons for reactions and comments
                    HStack {
                        Button(action: {
                            // Dummy action for "Like"
                        }) {
                            Image(systemName: "hand.thumbsup")
                        }
                        Button(action: {
                            // Dummy action for "Comment"
                        }) {
                            Image(systemName: "message")
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Community Hub")
        }
    }
}

// MARK: - Location-Based Opportunity Highlights

struct LocationHighlightsView: View {
    @State private var selectedLocation: String = "Your Area"
    // Dummy local opportunities
    let localOpportunities = [
        "Local Food Bank Volunteer",
        "Community Clean-Up Initiative",
        "Local Library Event"
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Highlights for:")
                    Text(selectedLocation)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                ForEach(localOpportunities, id: \.self) { opportunity in
                    Text("• \(opportunity)")
                        .padding(.leading)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Local Highlights")
        }
    }
}

// MARK: - Main ContentView Combining All Features

struct ContentView: View {
    var body: some View {
        TabView {
            OpportunityFeedView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Feed")
                }
            ProfileCustomizationView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
            EventListingsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
            CommunityHubView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Community")
                }
            LocationHighlightsView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Local")
                }
        }
    }
}
