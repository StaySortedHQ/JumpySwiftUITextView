//
//  ContentView.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MyTextView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyTextView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        // TextKit2 UITextView
        let view = UITextView(usingTextLayoutManager: true)
        view.backgroundColor = .tertiarySystemFill
        view.text = sampleContent
        view.delegate = context.coordinator
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            let p = CGPoint(x: 0, y: 2331)
            // Maximum content offset in this demo is (0.0, 2331.0).
            // We expect scroll view to scroll to bottom, however it doesn't move at all if animated is set to false
            view.setContentOffset(p, animated: false)
            
            // Setting animated to true can scroll the scroll view to bottom
            // view.setContentOffset(p, animated: true)
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: MyTextView
        
        init(_ parent: MyTextView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** contentOffset: \(scrollView.contentOffset)")
        }
    }
}

struct MyScrollView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIScrollView()
        view.backgroundColor = .gray
        
        let redSquare = UIView()
        redSquare.backgroundColor = .red
        redSquare.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.addSubview(redSquare)
        
        let greenSquare = UIView()
        greenSquare.backgroundColor = .green
        greenSquare.frame = CGRect(x: 0, y: 5000, width: 100, height: 100)
        view.addSubview(greenSquare)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            view.contentOffset = CGPoint(x: 0, y: 5000)
            print("*** contentOffset: \(view.contentOffset)")
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIScrollViewDelegate {
        
        let parent: MyScrollView
        
        init(_ parent: MyScrollView) {
            self.parent = parent
            super.init()
        }
        
    }
}


let sampleContent = """
    Choosing the Right Extension Approach Choosing the Right Extension Approach Choosing the Right Extension Approach Choosing the Right Extension Approach

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.

    We’ve looked at the built-in text controls, the components in the TextKit stack, and how to configure those components to achieve different effects.  There’s a lot you can do with that knowledge already, but if you need even more, you’ll need to extend parts of TextKit.  So now we’ll talk a little bit about choosing the right approach for that.  And choosing the right approach is like building up your text toolbox.  It’s like going to the hardware store because you need a hammer, and then when you get there, there’s this giant wall of hammers to choose from.  You want to pick the hammer that can do the job, and the least expensive one that will do what you need.  So these are the hammers that are available to us.  Delegation is like your standard hammer with the claw on the end, it’s useful for multiple tasks.  The delegates have a lot of commonly desired customization hooks and most of the time it’ll get the job done.  Notifications is like a ball-peen hammer, which has a ball on the end instead of a claw.  It’s more specialized and better suited for certain tasks than the standard hammer of delegation, but it’s not quite as versatile.  And finally, subclassing is your sledgehammer.  You can use the sledgehammer for just about anything you’d need a hammer for, but it’s probably overkill for a lot of things.
"""
