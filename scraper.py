from bs4 import BeautifulSoup
import csv


with open('/Users/hansamemiya/Documents/Players Bios _ Stats _ NBA.com.html') as file:
   soup = BeautifulSoup(file, 'html.parser')


table_body = soup.find('tbody', class_='Crom_body__UYOcU')


with open('player_stats.csv', 'w', newline='') as csv_file:
   writer = csv.writer(csv_file)
   writer.writerow(['Name', 'Team', 'Height', 'Weight', 'PPG', "Net Rating"])


   for row in table_body.find_all('tr'):
       name = row.find('td', class_='Crom_text__NpR1_ Crom_sticky__uYvkp Crom_player__BuOU9').text.strip()
       team_elements = row.find_all('a', class_='Anchor_anchor__cSc3P')
       team = team_elements[1].text.strip() if len(team_elements) > 1 else '' 




       height = row.find_all('td')[3].text.strip()
       weight = row.find_all('td')[4].text.strip()
       ppg = row.find_all('td')[11].text.strip()
       netrtg = row.find_all('td')[14].text.strip()


    
       writer.writerow([name.ljust(20), team.ljust(20), height.ljust(10), weight.ljust(10), ppg.ljust(10), netrtg.ljust(10)])
