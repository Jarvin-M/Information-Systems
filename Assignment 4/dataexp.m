shoppingList = readDataFile;
entireDB = string([shoppingList{:}]);
unique_items = unique(entireDB);
n_items = length(unique_items);

freq = zeros(1,n_items);

for i=1:n_items
    freq(i) = sum(entireDB == unique_items{i});
    
end

bar(freq);
set(gca, 'XTickLabel',unique_items, 'XTick',1:size(unique_items, 2))
set(gca,'XTickLabelRotation',90)
title('Grocery Items in the transactions')
ylabel('# of Occurences')
print('histogram.png', '-dpng')

minsup = 0.001;
minconf =0.8;
antimonotone =false;
rules = associationRules(minsup,minconf, antimonotone);

ss = sortrows(rules, 3, 'descend');
top30 = ss(1:30, :);

top30str ={};
fileID = fopen('textfile8.txt', 'a');
for i =1:size(top30,1)
    top30str{i,1} = [unique_items(top30{i,1})];
%     top30str{i,2} = unique_items(top30{i,2});
    nn = length(unique_items(top30{i,1}));
    bb = unique_items(top30{i,1});
    for ii = 1:nn
        fprintf(fileID, '``%s" \t', bb(ii));
    end
        fprintf(fileID, 'Rightarrow ``%s"\n', unique_items(top30{i,2}));
end