//
//  DraggingManager.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/28/22.
//

// Helper class for dragging objects inside LazyVGrid.
// Grid items must be of the same size
import SwiftUI

final class DraggingManager<Entry: Identifiable>: ObservableObject {
    
    let coordinateSpaceID = UUID()
    
    private var gridDimensions: CGRect = .zero
    private var numberOfColumns = 0
    private var numberOfRows = 0
    private var framesOfEntries = [Int: CGRect]() // Positions of entries views in coordinate space
    
    func setFrameOfEntry(at entryIndex: Int, frame: CGRect) {
        guard draggedEntry == nil else { return }
        framesOfEntries[entryIndex] = frame
    }
    
    var initialEntries: [Entry] = [] {
        didSet {
            entries = initialEntries
            calculateGridDimensions()
        }
    }
    @Published // Currently displayed (while dragging)
    var entries: [Entry]?
    
    var draggedEntry: Entry? { // Detected when dragging starts
        didSet { draggedEntryInitialIndex = initialEntries.firstIndex(where: { $0.id == draggedEntry?.id })
        }
    }
    var draggedEntryInitialIndex: Int?
    
    var draggedToIndex: Int? { // Last index where device was dragged to
        didSet {
            guard let draggedToIndex, let draggedEntryInitialIndex, let draggedEntry else { return }
            var newArray = initialEntries
            newArray.remove(at: draggedEntryInitialIndex)
            newArray.insert(draggedEntry, at: draggedToIndex)
            withAnimation {
                entries = newArray
            }
        }
    }

    func indexForPoint(_ point: CGPoint) -> Int {
        let x = max(0, min(Int((point.x - gridDimensions.origin.x) / gridDimensions.size.width), numberOfColumns - 1))
        let y = max(0, min(Int((point.y - gridDimensions.origin.y) / gridDimensions.size.height), numberOfRows - 1))
        return max(0, min(y * numberOfColumns + x, initialEntries.count - 1))
    }

    private func calculateGridDimensions() {
        let allFrames = framesOfEntries.values
        let rows = Dictionary(grouping: allFrames) { frame in
            frame.origin.y
        }
        numberOfRows = rows.count
        numberOfColumns = rows.values.map(\.count).max() ?? 0
        let minX = allFrames.map(\.minX).min() ?? 0
        let maxX = allFrames.map(\.maxX).max() ?? 0
        let minY = allFrames.map(\.minY).min() ?? 0
        let maxY = allFrames.map(\.maxY).max() ?? 0
        let width = (maxX - minX) / CGFloat(numberOfColumns)
        let height = (maxY - minY) / CGFloat(numberOfRows)
        let origin = CGPoint(x: minX, y: minY)
        let size = CGSize(width: width, height: height)
        gridDimensions = CGRect(origin: origin, size: size)
    }
        
}

struct Draggable<Entry: Identifiable>: ViewModifier {
    
    @Binding
    var originalEntries: [Entry]
    let draggingManager: DraggingManager<Entry>
    let entry: Entry

    @ViewBuilder
    func body(content: Content) -> some View {
        if let entryIndex = originalEntries.firstIndex(where: { $0.id == entry.id }) {
            let isBeingDragged = entryIndex == draggingManager.draggedEntryInitialIndex
            let scale: CGFloat = isBeingDragged ? 1.1 : 1.0
            content.background(
                GeometryReader { geometry -> Color in
                    draggingManager.setFrameOfEntry(at: entryIndex, frame: geometry.frame(in: .named(draggingManager.coordinateSpaceID)))
                    return .clear
                }
            )
            .scaleEffect(x: scale, y: scale)
            .gesture(
                dragGesture(
                    draggingManager: draggingManager,
                    entry: entry,
                    originalEntries: $originalEntries
                )
            )
        }
        else {
            content
        }
    }
    
    func dragGesture<Entry: Identifiable>(draggingManager: DraggingManager<Entry>, entry: Entry, originalEntries: Binding<[Entry]>) -> some Gesture {
        DragGesture(coordinateSpace: .named(draggingManager.coordinateSpaceID))
            .onChanged { value in
                // Detect start of dragging
                if draggingManager.draggedEntry?.id != entry.id {
                    withAnimation {
                        draggingManager.initialEntries = originalEntries.wrappedValue
                        draggingManager.draggedEntry = entry
                    }
                }
                
                let point = draggingManager.indexForPoint(value.location)
                if point != draggingManager.draggedToIndex {
                    draggingManager.draggedToIndex = point
                }
                withAnimation {
                    originalEntries.wrappedValue = draggingManager.entries!
                }
                
            }
            .onEnded { value in
                withAnimation {
                    originalEntries.wrappedValue = draggingManager.entries!
                    draggingManager.entries = nil
                    draggingManager.draggedEntry = nil
                    draggingManager.draggedToIndex = nil
                }
            }
    }
}

extension View {
    // Allows item in LazyVGrid to be dragged between other items.
    func draggable<Entry: Identifiable>(draggingManager: DraggingManager<Entry>, entry: Entry, originalEntries: Binding<[Entry]>) -> some View {
        self.modifier(Draggable(originalEntries: originalEntries, draggingManager: draggingManager, entry: entry))
    }
}
