# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/proposals/participatory_texts/_view_index",
                     name: "add_scope_filter_to_participatory_texts",
                     insert_before: "div#participatory-text-index",
                     text: "
                        <% if current_user&.admin? %>
                          <div class='card card__link p-xs flex--fsc reveal__trigger filter-by-scope' data-open='participatory-text-index'>
                            <%= icon 'list', class: 'mr-s', role: 'img', 'aria-hidden': true %>
                            <strong><%= t('decidim.components.proposals.participatory_texts.filter_by_scope') %></strong>
                          </div>
                          <div id='participatory-text-index' class='reveal large' data-reveal>
                            <div class='p-s'>
                            <h4>Filtrar por ámbito</h4>
                            <div class='text-muted'>
                            <div class='mb-s'>
                              <p>
                                <%= link_to proposals_path(scope: nil) do %>
                                  <u><%= t('decidim.components.proposals.participatory_texts.all_scopes') %></u>
                                  <br>
                                <% end %>
                              </p>
                            </div>
                              <% Decidim::Scope.all.each do |scope| %>
                                <div class='mb-s'>
                                  <p>
                                    <%= link_to proposals_path(scope: scope.id) do %>
                                      <u><%= translated_attribute(scope.name) %></u>
                                      <br>
                                    <% end %>
                                  </p>
                                </div>
                              <% end %>
                            </div>
                          </div>
                          <button class='close-button' data-close aria-label='Close reveal' type='button'>
                            <span aria-hidden='true'>&times;</span>
                          </button>
                        </div>
                        <% end %>
                      ",
                     original: "e8ac95ba03285418fa2162241a0100b62838bedb")
