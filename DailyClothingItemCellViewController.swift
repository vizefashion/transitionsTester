//
//  DailyClothingItemCellViewController.swift
//  Vize
//
//  Created by Jerome Ley on 8/24/16.
//  Copyright © 2016 Vize. All rights reserved.
//

import UIKit

class DailyClothingItemCellViewController: UIViewController, UIScrollViewDelegate {

    var category: ClothingCategory?
    
    @IBOutlet weak var clothingItemScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var clothingCategoryLabel: UILabel!
    @IBOutlet weak var itemDetailLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    let itemViewAspectRatio: CGFloat = 1.05
    let productCellHeightDifferenceConstant: CGFloat = -16.0
    var productCellWidth: CGFloat = 0.0
    
    var centralIndex: Int = 0
    var itemViews: [UIView?] =      [nil, nil, nil, nil, nil, nil, nil]
    var itemImageViews: [UIImageView?] = [nil, nil, nil, nil, nil, nil, nil]
    
    /* Button and Label functions */
    @IBAction func button1Tapped(_ sender: AnyObject) {
        button1.isSelected = !button1.isSelected
    }
    
    @IBAction func button2Tapped(_ sender: AnyObject) {
    }
    
    func updateLabelsAndButtonsForItem(_ item: Any) {
        switch item {
        case is Product:
            let details = item as! Product
            itemDetailLabel.text = details.nameToDisplay()
            
            //Change buttons
            
        default:
            break
        }
        if false { //probabily nil or something
            return
        }
    }

    /* Item view functions */
    func displayItemsForCategory(_ category: ClothingCategory) {
        //Load the product views
        self.category = category
        self.centralIndex = 0
        clothingCategoryLabel.text = self.category!.rawValue
        
        updateLabelsAndButtonsForItem(itemAtDistanceFromCentralIndex(0))
        
        addItemView(itemAtDistanceFromCentralIndex(0), atPosition: 3)
        addItemView(itemAtDistanceFromCentralIndex(-1), atPosition: 2)
        addItemView(itemAtDistanceFromCentralIndex(-2), atPosition: 1)
        addItemView(itemAtDistanceFromCentralIndex(-3), atPosition: 0)
        addItemView(itemAtDistanceFromCentralIndex(1), atPosition: 4)
        addItemView(itemAtDistanceFromCentralIndex(2), atPosition: 5)
        addItemView(itemAtDistanceFromCentralIndex(3), atPosition: 6)
        
        DispatchQueue.main.async(execute: {
            self.centerScrollView()
        })
    }
    
    func centerScrollView() {
        // determines what "bin" to display.
        let kMaxIndex: CGFloat = CGFloat(itemViews.count - 1)
        let targetIndex: CGFloat = 3
        
        let xOffset = (contentViewWidth.constant/2.0-clothingItemScrollView.frame.width/2.0) + (targetIndex-kMaxIndex/2.0) * (productCellWidth)
        
        print("Centering about xOffset \(xOffset)")
        self.clothingItemScrollView.setContentOffset(CGPoint(x: xOffset, y: 0.0), animated: false)
        
        updateLabelsAndButtonsForItem(itemAtDistanceFromCentralIndex(Int(targetIndex) - 3))
    }
    
    func itemAtDistanceFromCentralIndex(_ distance: Int) -> Any? {
        //Returns the item at a distance from the central index. The items are treated as a circular array
        if let items = StateController.shared.dailyController.dailyItems[self.category!] {
            var newIndex = centralIndex + distance
            while newIndex < 0 || newIndex >= items.count {
                newIndex += (newIndex < 0) ? items.count : -(items.count)
            }
            return items[newIndex]
        } else {
            print("Error - Category not found in daily items.")
            return nil
        }
    }
    
    func addItemView(_ item: Any?, atPosition position: Int) {
        guard let checkItem = item else {
            return
        }
        
        //Create the product image wrapper
        let newView = UIView()
        //newView.backgroundColor = UIColor(colorLiteralRed: 1.0, green: Float(4-position)*0.2, blue: Float(position)*0.2, alpha: 1.0)
        newView.translatesAutoresizingMaskIntoConstraints = false
    
        //Set constraints
        let heightConstraint = NSLayoutConstraint(item: newView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: productCellHeightDifferenceConstant)
        let widthConstraint = NSLayoutConstraint(item: newView, attribute: .width, relatedBy: .equal, toItem: newView, attribute: .height, multiplier: itemViewAspectRatio, constant: 0.0)
        let verticalConstraint = NSLayoutConstraint(item: newView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        var horizontalConstraint: NSLayoutConstraint?
        if(position == 3) { // The centrally-displayed item
            horizontalConstraint = NSLayoutConstraint(item: newView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        } else if(position > 3) { // The centrally-displayed item
            horizontalConstraint = NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: itemViews[position-1], attribute: .trailing, multiplier: 1.0, constant: 0.0)
        } else if(position < 3) { // The centrally-displayed item
            horizontalConstraint = NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: itemViews[position+1], attribute: .leading, multiplier: 1.0, constant: 0.0)
        }
        
        //Create the product image
        let productImage: UIImageView = UIImageView()
        productImage.clipsToBounds = true
        productImage.contentMode = .scaleAspectFill
        
        switch item {
        case is Product:
            productImage.imageFromUrl((item as! Product).imageURL)
        default:
            break
        }
        if false { //probabily nil or something
            return
        }
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint2 = NSLayoutConstraint(item: productImage, attribute: .height, relatedBy: .equal, toItem: newView, attribute: .height, multiplier: 1.0, constant: 0.0)
        let widthConstraint2 = NSLayoutConstraint(item: productImage, attribute: .width, relatedBy: .equal, toItem: productImage, attribute: .height, multiplier: 1.0, constant: 0.0)
        let verticalConstraint2 = NSLayoutConstraint(item: productImage, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let horizontalConstraint2 = NSLayoutConstraint(item: productImage, attribute: .centerX, relatedBy: .equal, toItem: newView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        DispatchQueue.main.async(execute: {
            newView.addSubview(productImage)
            self.contentView.addSubview(newView)
            self.view.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint!])
            self.view.addConstraints([heightConstraint2, widthConstraint2, verticalConstraint2, horizontalConstraint2])
        })
        
        itemImageViews[position] = productImage
        itemViews[position] = newView
    }
    
    /* Scrollview Delegate Functions */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //shift the scroll view images
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //Function to implement custom paging in the scrollview
        let kMaxIndex: CGFloat = CGFloat(itemViews.count - 1)
        let velocityScalingFactor:CGFloat = 60.0
        
        // determines what the target x coordinate will be after swiping.
        let targetX: CGFloat = scrollView.contentOffset.x + velocity.x*velocityScalingFactor
        
        // determines what "bin" to display.
        var targetIndex: CGFloat = floor((targetX + 0.5*clothingItemScrollView.frame.width) / (productCellWidth))
        
        print("Scrollview will end dragging with scrollView.contentOffset.x =\(scrollView.contentOffset.x), clothingItemScrollView.frame.width = \(clothingItemScrollView.frame.width), productCellWidth = \(productCellWidth)")
        
        //Keep the index in range
        if(targetIndex < 0) {
            targetIndex = 0
        } else if(targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }
        
        //Adjust the view
        targetContentOffset.pointee.x = (contentViewWidth.constant/2.0-clothingItemScrollView.frame.width/2.0) + (targetIndex-kMaxIndex/2.0) * (productCellWidth)
        
        updateLabelsAndButtonsForItem(itemAtDistanceFromCentralIndex(Int(targetIndex) - 3))
    }
    
    /* View functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        button1.stylizeWithVizeButtonStyle(.filledGoldSelectedWhiteDeselected, bold: false)
        button2.stylizeWithVizeButtonStyle(.filledInWhiteGoldBorder, bold: false)
        clothingCategoryLabel.stylizeWithVizeLabelStyle(.header, bold: false)
        itemDetailLabel.stylizeWithVizeLabelStyle(.smallText, bold: false)
        clothingItemScrollView.decelerationRate = UIScrollViewDecelerationRateFast
    }

    override func viewDidLayoutSubviews() {
        self.view.layoutSubviews()
        productCellWidth = itemViewAspectRatio*(contentViewHeight.constant+productCellHeightDifferenceConstant)
        let newConstantViewWidth = CGFloat(itemViews.count)*(productCellWidth)
        DispatchQueue.main.async(execute: {
            self.contentViewWidth.constant = newConstantViewWidth
        })
        clothingItemScrollView.contentOffset = CGPoint(x: (newConstantViewWidth-clothingItemScrollView.frame.width)/2.0, y: 0.0)
        
        print("Views laying out with productCellWidth = \(productCellWidth), contentViewWidth.constant = \(contentViewWidth.constant), contentViewHeight.constant = \(newConstantViewWidth)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //NEXT STEPS are coming up with a way to populate the clothingItemScrollView with a bunch of "Pages", then work on dynamically changing in and out the image views and whatever. Keep in mind that you need to add a content view and follow that tutorial 2 a tea
    
    /*@IBAction func clothingItemViewPanned(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            directionSet = false
            print("Began pan")
        case .Changed:
            //print("Changed pan \(sender.translationInView(clothingItemView))")
            if !directionSet {
                let translation = sender.translationInView(clothingItemView)
                if(fabs(translation.x) > directionThreshold) {
                    directionSet = true
                    directionIsHorizontal = true
                    print("Set direction to horizontal")
                } else if(fabs(translation.y) > directionThreshold) {
                    directionSet = true
                    directionIsHorizontal = false
                    print("Set direction to vertical")
                    self.superVC?.beginClothingItemCellPan()
                }
            } else {
                if directionIsHorizontal {
                    //Scroll the clothing view
                } else {
                    //Pass along the data to the superview
                    self.superVC?.clothingItemCellPannedVertically(sender.translationInView(clothingItemView))
                }
            }
        case .Cancelled, .Ended:
            print("Stopped pan")
            if directionIsHorizontal {
                //Realign the clothing items
                
            }
        default:
            print("Other case")
        }
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


