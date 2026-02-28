import SwiftUI

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    init(_ placeholder: String = "Search...", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTextSecondary)
            
            TextField(placeholder, text: $text)
                .font(.bodyMedium)
                .foregroundStyle(Color.appTextPrimary)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
        }
        .padding(12)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search")
    }
}

// MARK: - Category Pill
struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyMedium)
                .foregroundStyle(isSelected ? .white : Color.appTextPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.appBrand : Color.appCardBackground)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Previews
#Preview("Search Bar") {
    @Previewable @State var text = ""
    SearchBar("Search courses...", text: $text)
        .padding()
}

#Preview("Category Pills") {
    HStack {
        CategoryPill(title: "All", isSelected: true) {}
        CategoryPill(title: "Productivity", isSelected: false) {}
    }
    .padding()
}
