require_relative '../config/environment'

word = "kfjskdjfkdj"

def get_hint(word)
    th_url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=b026f64f-2167-4a30-8f7c-6effdf95c336"
    response = RestClient.get(th_url)
    obj = JSON.parse(response)
    
    dic_url = "https://dictionaryapi.com/api/v3/references/collegiate/json/#{word}?key=fcaaacd2-b734-4cfb-8946-ff1484435c66"
    dict_response = RestClient.get(dic_url)
    dict_obj = JSON.parse(dict_response)
    # binding.pry
    if obj[0].class != String && !obj.empty?
        hint = obj[0]["meta"]["syns"].flatten.sample + " (synonym)"
    elsif dict_obj[0].class == Hash
        hint = dict_obj[0]["shortdef"].flatten.first
    else
        hint = "Experts and Masters don't need no hints."
    end
    return hint 
end

x = get_hint(word)
binding.pry
0