
//

import UIKit



class DetailTableCell: UITableViewCell {
    
    var conditionId = 0
    
    var conditionName: String {
        
        switch conditionId {
        case 200...232:
            return "cloud.bolt.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.bolt.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.bolt.fill"
        default:
            return "sun.max.fill"
            
        }
        
    }
    
    let dayLabel = UILabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: .label)
    let humidityLabel = UILabel(font: UIFont.systemFont(ofSize: 12, weight: .semibold), textColor: .systemBlue)
    
    let temperatureLabel = UILabel(font: UIFont.systemFont(ofSize: 12, weight: .semibold), textColor: .label)
    
    let weatherIcon: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        iv.contentMode = .scaleToFill
        
        return iv
    }()
    
    var day: Daily? {
        didSet {
            
            guard let day = day else {
                return
            }
            
            conditionId = day.weather[0].id
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let date = NSDate(timeIntervalSince1970: day.dt)
            let dayName = formatter.string(from: date as Date)
            
            dayLabel.text = dayName
            
            humidityLabel.text = String(day.humidity) + "%"
            temperatureLabel.text = String(format: "%.1f", day.temp.day) + "°C"
            
            let config = UIImage.SymbolConfiguration(paletteColors: [
                .systemPurple, .systemPink])
            
            var image = UIImage(systemName: conditionName, withConfiguration: config)
            weatherIcon.image = image
            
            
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpCellView() {
        addSubview(dayLabel)
        addSubview(temperatureLabel)
        addSubview(weatherIcon)
        addSubview(humidityLabel)
        
        dayLabel.setHeight(40)
        dayLabel.centerY(inView: contentView)
        dayLabel.anchor(leading: leadingAnchor, paddingLeading: 8 )
        
        let stack = UIStackView(arrangedSubviews: [
        weatherIcon,
        humidityLabel
        ])
        
        stack.axis = .horizontal
        stack.spacing = 4
        addSubview(stack)
        stack.center(inView: contentView)
        
        temperatureLabel.setHeight(40)
        temperatureLabel.centerY(inView: contentView)
        temperatureLabel.anchor(trailing: contentView.trailingAnchor, paddingTrailing: 8)
        
        
    }
    
}
